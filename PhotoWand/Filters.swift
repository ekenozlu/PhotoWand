//
//  File.swift
//  PhotoWand
//
//  Created by Eken Özlü on 7.06.2023.
//

import UIKit

struct Filters {
    var filterImage: UIImage!
    var CIFilterName: String!
    var filterName: String!
    var inputKeyName: String!
    var minValue: Int!
    var maxValue: Int!
    var defaultValue: Int!
}

var filtersArray = [Filters]()

var exposureFilter = Filters(filterImage: UIImage(systemName: "sun.max"),
                             CIFilterName: "CIExposureAdjust",
                             filterName: "Exposure",
                             inputKeyName: "inputEV",
                             minValue: -100, maxValue: 100, defaultValue: 0)

var contrastFilter = Filters(filterImage: UIImage(systemName: "circle.righthalf.filled"),
                             CIFilterName: "CIColorControls",
                             filterName: "Contrast",
                             inputKeyName: "inputContrast",
                             minValue: -100, maxValue: 100, defaultValue: 0)


func setFiltersArray() {
    filtersArray.append(exposureFilter)
    filtersArray.append(contrastFilter)
}





