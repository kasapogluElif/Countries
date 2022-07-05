//
//  DetailDataModel.swift
//  Countries
//
//  Created by Elif Kasapoglu on 3.07.2022.
//

import Foundation

struct DetailDataModel: Codable{
    let data: CountryDetail
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}
