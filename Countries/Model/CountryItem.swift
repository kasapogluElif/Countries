//
//  CountryItem.swift
//  Countries
//
//  Created by Elif Kasapoglu on 3.07.2022.
//

import Foundation
import UIKit

struct CountryItem{
    let countryInfo: CountryDataModel?
    var saveImage = UIImage(systemName: "star")
    var isSaved = false {
        didSet {
            saveImage = isSaved ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        }
    }
}
