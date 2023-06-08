//
//  File.swift
//  PhotoWand
//
//  Created by Eken Özlü on 7.06.2023.
//

import UIKit
import CoreImage

struct Filter {
    var filterImage: UIImage!
    var CIFilterName: String!
    var filterName: String!
    var inputKeyName: String!
    var minValue: Float!
    var maxValue: Float!
    var defaultValue: Float!
}

var filtersArray = [Filter]()

var brightnessFilter    = Filter(filterImage: UIImage(systemName: "sun.max"),
                                 CIFilterName: "CIColorControls",
                                 filterName: "Brightness",
                                 inputKeyName: kCIInputBrightnessKey,
                                 minValue: -1.0, maxValue: 1.0, defaultValue: 0.0)

var exposureFilter      = Filter(filterImage: UIImage(systemName: "microbe.fill"),
                                 CIFilterName: "CIExposureAdjust",
                                 filterName: "Exposure",
                                 inputKeyName: kCIInputEVKey,
                                 minValue: -1.0, maxValue: 1.0, defaultValue: 0.0)

var contrastFilter      = Filter(filterImage: UIImage(systemName: "circle.righthalf.filled"),
                                 CIFilterName: "CIColorControls",
                                 filterName: "Contrast",
                                 inputKeyName: kCIInputContrastKey,
                                 minValue: 0.0, maxValue: 1.0, defaultValue: 0.0)

var saturationFilter    = Filter(filterImage: UIImage(systemName: "s.square"),
                                CIFilterName: "CIColorControls",
                                 filterName: "Saturation",
                                 inputKeyName: kCIInputSaturationKey,
                                 minValue: 0.0, maxValue: 1.0, defaultValue: 0.0)

var SharpnessFilter     = Filter(filterImage: UIImage(systemName: "triangle"),
                                 CIFilterName: "CINoiseReduction",
                                 filterName: "Sharpness",
                                 inputKeyName: kCIInputSharpnessKey,
                                 minValue: 0.0, maxValue: 1.0, defaultValue: 0.0)

var hueFilter           = Filter(filterImage: UIImage(systemName: "drop.fill"),
                                 CIFilterName: "CIHueAdjust",
                                 filterName: "Hue",
                                 inputKeyName: kCIInputAngleKey,
                                 minValue: 0.0, maxValue: 1.0, defaultValue: 0.0)

var GaussianBlur        = Filter(filterImage: UIImage(systemName: "g.square"),
                                 CIFilterName: "CIGaussianBlur",
                                 filterName: "Gaussian Blur",
                                 inputKeyName: kCIInputRadiusKey,
                                 minValue: 0.0, maxValue: 1.0, defaultValue: 0.0)

var MotionBlur        = Filter(filterImage: UIImage(systemName: "figure.run"),
                                 CIFilterName: "CIMotionBlur",
                                 filterName: "Motion Blur",
                                 inputKeyName: kCIInputRadiusKey,
                                 minValue: 0.0, maxValue: 1.0, defaultValue: 0.0)


func setFiltersArray() {
    filtersArray.append(brightnessFilter)
    filtersArray.append(exposureFilter)
    filtersArray.append(contrastFilter)
    filtersArray.append(hueFilter)
    filtersArray.append(GaussianBlur)
    filtersArray.append(MotionBlur)
}





