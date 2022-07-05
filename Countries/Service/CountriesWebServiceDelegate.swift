//
//  CountriesWebServiceDelegate.swift
//  Countries
//
//  Created by Elif Kasapoglu on 3.07.2022.
//

import Foundation

protocol CountriesWebServiceDelegate {
    func didFetchCountries(countries: [CountryItem])
    func didFetchDetails(details: DetailDataModel)
    func didFailWithError(error: Error)
}

extension CountriesWebServiceDelegate{
    func didFailWithError(error: Error){
        print(error)
    }
    
    func didFetchCountries(countries: [CountryItem]){}
    func didFetchDetails(details: DetailDataModel){}
}
