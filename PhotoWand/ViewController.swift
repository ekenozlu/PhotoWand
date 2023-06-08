//
//  ViewController.swift
//  PhotoWand
//
//  Created by Eken Özlü on 7.06.2023.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    @IBOutlet weak var currentFilterImage: UIImageView!
    @IBOutlet weak var sliderValueLabel: UILabel!
    @IBOutlet weak var intensitySlider: UISlider!
    @IBOutlet weak var saveButton: UIButton!
    
    var currentImage: UIImage!
    var currentFilter: CIFilter!
    let context = CIContext()
    
    var currentFilterIndex: Int! = 0
    var appliedFilters = [Filter]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setControlButtons(toEnabled: false)
        setFiltersArray()
        applySliderAndImage()
        
        currentFilter = CIFilter(name: filtersArray[currentFilterIndex].CIFilterName)
        
        var longPressRecogniser = UILongPressGestureRecognizer()
        longPressRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(imageLongPressed))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(longPressRecogniser)
    }
    
    @IBAction func addTapped(_ sender: Any) {
        showImagePickerOptions()
    }
    
    @IBAction func intensitySliderChanged(_ sender: Any) {
        sliderValueLabel.text = String(Int(intensitySlider.value * 100))
        filtersArray[currentFilterIndex].defaultValue = intensitySlider.value
        applyProcessing()
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let image = imageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveImage(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func showImagePickerOptions() {
        let ac = UIAlertController(title: "Pick a photo for editing",
                                   message: "Take a new one from camera or chooes from Library",
                                   preferredStyle: .actionSheet)
        
        //From Camera
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] (action) in
            guard let self = self else { return }
            let cameraImagePicker = self.imagePicker(sourceType: .camera)
            cameraImagePicker.delegate = self
            self.present(cameraImagePicker, animated: true) {
                // TO DO
            }
        }
        
        //From Library
        let libraryAction = UIAlertAction(title: "Library", style: .default) { [weak self] (action) in
            guard let self = self else { return }
            let libraryImagePicker = self.imagePicker(sourceType: .photoLibrary)
            libraryImagePicker.delegate = self
            self.present(libraryImagePicker, animated: true) {
                // TO DO
            }
        }
        
        //Cancel
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        ac.addAction(cameraAction)
        ac.addAction(libraryAction)
        ac.addAction(cancelAction)
        self.present(ac, animated: true)
    }
    
    func imagePicker(sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        return imagePicker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        
        currentImage = image
        dismiss(animated: true)
        
        setControlButtons(toEnabled: true)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return filtersArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = filtersCollectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as! FilterCVCell
        
        cell.filterImage.image = filtersArray[indexPath.row].filterImage
        cell.filterLabel.text = filtersArray[indexPath.row].filterName
        
        if appliedFilters.contains(where: { filter in filter.filterName == cell.filterLabel.text }) {
            cell.filterImage.tintColor = UIColor(named: "AppGreen")
            cell.filterLabel.textColor = UIColor(named: "AppGreen")
        }
        else {
            cell.filterImage.tintColor = .label
            cell.filterLabel.textColor = .label
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentFilterIndex = indexPath.row
        applySliderAndImage()
        setFilter()
    }
    
    func applyProcessing() {
        filtersCollectionView.reloadData()
        appliedFilters.removeAll { filter in
            filter.CIFilterName == filtersArray[currentFilterIndex].CIFilterName
        }
        
        if intensitySlider.value != 0 {
            appliedFilters.append(filtersArray[currentFilterIndex])
        }
        
        if let cgImage = context.createCGImage(allFiltersApplied(currentFilter.outputImage!),
                                               from: allFiltersApplied(currentFilter.outputImage!).extent) {
            let processedImage = UIImage(cgImage: cgImage)
            self.imageView.image = processedImage
        }
    }
    
    func allFiltersApplied(_ image: CIImage) -> CIImage {
        var tempImage = image
        for filter in appliedFilters {
            let tempImage2 : CIImage = tempImage.applyingFilter(filter.CIFilterName, parameters: [filter.inputKeyName:filter.defaultValue!])
            tempImage = tempImage2
        }
        return tempImage
    }
    
    func setFilter() {
        guard currentImage != nil else { return }
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func applySliderAndImage() {
        let filter = filtersArray[currentFilterIndex]
        currentFilterImage.image = filter.filterImage
        intensitySlider.minimumValue = Float(filter.minValue)
        intensitySlider.maximumValue = Float(filter.maxValue)
        intensitySlider.value = Float(filter.defaultValue)
        sliderValueLabel.text = String(Int(intensitySlider.value * 100))
    }
    
    @objc func imageLongPressed(recogniser:UILongPressGestureRecognizer) {
        switch recogniser.state {
        case .began:
            if currentImage != nil {
                self.imageView.image = currentImage
            }
            
        case .ended:
            if currentImage != nil {
                applyProcessing()
            }
            
        default: break
        }
    }
    
    @objc func saveImage(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer){
        if let error = error {
            let ac = UIAlertController(title: "Save Error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        else {
            let ac = UIAlertController(title: "Saved", message: "Your image is succesfully saved", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue editing", style: .default))
            ac.addAction(UIAlertAction(title: "Finish editing", style: .default, handler: { _ in
                //Clear all
                self.currentImage = nil
                self.imageView.image = self.currentImage
                self.currentFilterIndex = 0
                self.setControlButtons(toEnabled: false)
                self.appliedFilters.removeAll()
                setFiltersValuesToZero()
                self.applySliderAndImage()
                self.filtersCollectionView.reloadData()
            }))
            present(ac, animated: true)
        }
    }
    
    func setControlButtons(toEnabled boolIndex: Bool) {
        if boolIndex {
            saveButton.isEnabled = true
            intensitySlider.isEnabled = true
            currentFilterImage.tintColor = .label
            sliderValueLabel.textColor = .label
        }
        else {
            saveButton.isEnabled = false
            intensitySlider.isEnabled = false
            currentFilterImage.tintColor = .separator
            sliderValueLabel.textColor = .separator
        }
    }
    
}
