//
//  CountriesWebService.swift
//  Countries
//
//  Created by Elif Kasapoglu on 2.07.2022.
//

import Foundation

enum ServiceType {
    case list
    case detail
}

struct CountriesWebService{
    var delegate: CountriesWebServiceDelegate?
    
    let headers = [
        "X-RapidAPI-Key": "cd77f68b4dmsh785419e04294727p17935fjsn207e5c464c26",
        "X-RapidAPI-Host": "wft-geo-db.p.rapidapi.com"
    ]
    
    func fetchDetails(countryCode: String){
        if let url = NSURL(string: "https://wft-geo-db.p.rapidapi.com/v1/geo/countries/\(countryCode)") as? URL{
            performRequest(url: url,serviceType: .detail)
        }
    }
    
    func fetchCountries(){
        if let url = NSURL(string: "https://wft-geo-db.p.rapidapi.com/v1/geo/countries?limit=10") as? URL{
            performRequest(url: url,serviceType: .list)
        }
    }
    
    fileprivate func performRequest(url: URL, serviceType: ServiceType){
        
        let request = NSMutableURLRequest(url: url as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                delegate?.didFailWithError(error: error)
            }
            if let safeData = data{
                
                switch serviceType {
                case .detail:
                    if let detailData = parseJSONDetail(safeData){
                        delegate?.didFetchDetails(details: detailData)
                    }
                case .list:
                    if let countryListData = parseJSONList(safeData){
                        let countries = generateCountryList(countryListData: countryListData)
                        delegate?.didFetchCountries(countries: countries)
                    }
                }
            }
        })
        dataTask.resume()
    }
    
    fileprivate func generateCountryList(countryListData: CountriesDataModel) -> [CountryItem]{
        var countryList : [CountryItem] = []
        for data in countryListData.data{
            countryList.append(CountryItem(countryInfo: data))
        }
        return countryList
    }
    
    fileprivate func parseJSONList(_ countriesData: Data) -> CountriesDataModel?{
        do{
            let decodedData =  try JSONDecoder().decode(CountriesDataModel.self, from: countriesData)
            return decodedData
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    fileprivate func parseJSONDetail(_ detailData: Data) -> DetailDataModel?{
        do{
            let decodedData =  try JSONDecoder().decode(DetailDataModel.self, from: detailData)
            return decodedData
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
