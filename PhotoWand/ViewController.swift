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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFiltersArray()
        applySliderAndImage()
        
        currentFilter = CIFilter(name: filtersArray[currentFilterIndex].CIFilterName)
        saveButton.isEnabled = false
        intensitySlider.isEnabled = false
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
        //imageView.image = image
        currentImage = image
        
        saveButton.isEnabled = true
        intensitySlider.isEnabled = true
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
        
        setFilter()
        dismiss(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return filtersArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = filtersCollectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as! FilterCVCell
        
        cell.filterImage.image = filtersArray[indexPath.row].filterImage
        cell.filterLabel.text = filtersArray[indexPath.row].filterName
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentFilterIndex = indexPath.row
        applySliderAndImage()
        setFilter()
    }
    
    func applyProcessing() {
        
        let inputKey = filtersArray[currentFilterIndex].inputKeyName
        currentFilter.setValue(intensitySlider.value, forKey: inputKey!)
        
        if let cgImage = context.createCGImage(currentFilter.outputImage!, from: currentFilter.outputImage!.extent) {
            let processedImage = UIImage(cgImage: cgImage)
            self.imageView.image = processedImage
        }
    }
    
    func setFilter() {
        guard currentImage != nil else { return }
        
        currentFilter = CIFilter(name: filtersArray[currentFilterIndex].CIFilterName)
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
    
    
    
    
    @objc func saveImage(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer){
        if let error = error {
            let ac = UIAlertController(title: "Save Error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        else {
            let ac = UIAlertController(title: "Saved", message: "Your image is succesfully saved", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}
