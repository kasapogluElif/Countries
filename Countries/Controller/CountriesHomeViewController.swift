//
//  CountriesHomeViewController.swift
//  Countries
//
//  Created by Elif Kasapoglu on 2.07.2022.
//

import UIKit

class CountriesHomeViewController: UIViewController {
    
    @IBOutlet weak var countriesTableView: UITableView!
    fileprivate var countriesWebService = CountriesWebService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Countries"
        
        countriesTableView.delegate = self
        countriesTableView.dataSource = self
        
        countriesWebService.delegate = self
        countriesWebService.fetchCountries()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        countriesTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail", let detailVC = segue.destination as? DetailCardViewController, let country = sender as? CountryItem{
            detailVC.country = country
        }
    }
}

//MARK: - Tableview Delegate Methods
extension CountriesHomeViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CountryTableViewCell, let country = cell.country{
            performSegue(withIdentifier: "detail", sender: country)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - Tableview Datasource Methods
extension CountriesHomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = countriesTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CountryTableViewCell{
            let country =  CountryLists.countriesList[indexPath.row]
            cell.delegate = self
            cell.country = country
            cell.countryNameLabel.text = country.countryInfo?.name
            cell.saveImage.image = country.saveImage
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  CountryLists.countriesList.count
    }
}

//MARK: - Save Image Delegate Methods
extension CountriesHomeViewController: SaveImageDelegate{
    func didSaveImageTapped(country: CountryItem?) {
        if let name = country?.countryInfo?.name, let i =  CountryLists.countriesList.firstIndex(where: { $0.countryInfo?.name == name }) {
            CountryLists.countriesList[i].isSaved = !CountryLists.countriesList[i].isSaved
            CountryLists.savedCountriesList =  CountryLists.countriesList.filter({$0.isSaved == true})
            countriesTableView.reloadData()
        }
    }
}

//MARK: - Web Service Delegate Methods
extension CountriesHomeViewController: CountriesWebServiceDelegate{
    func didFetchCountries(countries: [CountryItem]) {
        DispatchQueue.main.async {
            CountryLists.countriesList = countries
            self.countriesTableView.reloadData()
        }
    }
}
