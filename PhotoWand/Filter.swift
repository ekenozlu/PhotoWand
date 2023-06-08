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
    var minValue: Int!
    var maxValue: Int!
    var defaultValue: Int!
}

var filtersArray = [Filter]()

var exposureFilter = Filter(filterImage: UIImage(systemName: "sun.max"),
                             CIFilterName: "CIExposureAdjust",
                             filterName: "Exposure",
                             inputKeyName: kCIInputEVKey,
                             minValue: -1, maxValue: 1, defaultValue: 0)

var contrastFilter = Filter(filterImage: UIImage(systemName: "circle.righthalf.filled"),
                             CIFilterName: "CIColorControls",
                             filterName: "Contrast",
                             inputKeyName: kCIInputContrastKey,
                             minValue: -1, maxValue: 1, defaultValue: 0)


func setFiltersArray() {
    filtersArray.append(exposureFilter)
    filtersArray.append(contrastFilter)
}





