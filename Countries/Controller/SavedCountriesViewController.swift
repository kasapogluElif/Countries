//
//  SavedCountriesViewController.swift
//  Countries
//
//  Created by Elif Kasapoglu on 3.07.2022.
//

import UIKit

class SavedCountriesViewController: UIViewController {
    
    @IBOutlet weak var savedCountriesTableView: UITableView!
    @IBOutlet weak var noDataView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Countries"
        
        savedCountriesTableView.dataSource = self
        savedCountriesTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        noDataView.isHidden = true
        savedCountriesTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail", let detailVC = segue.destination as? DetailCardViewController, let country = sender as? CountryItem{
            detailVC.country = country
        }
    }
}

//MARK: - Tableview Delegate Methods
extension SavedCountriesViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CountryTableViewCell, let country = cell.country{
            performSegue(withIdentifier: "detail", sender: country)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - Tableview Datasource Methods
extension SavedCountriesViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = CountryLists.savedCountriesList.count
        if count == 0{
            noDataView.isHidden = false
        }
        return  count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = savedCountriesTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CountryTableViewCell{
            let country =  CountryLists.savedCountriesList[indexPath.row]
            cell.delegate = self
            cell.country = country
            cell.countryNameLabel.text = country.countryInfo?.name
            cell.saveImage.image = country.saveImage
            return cell
        }
        return UITableViewCell()
    }
}

//MARK: - Save Image Delegate Methods
extension SavedCountriesViewController: SaveImageDelegate{
    func didSaveImageTapped(country: CountryItem?) {
        if let name = country?.countryInfo?.name, let i =  CountryLists.countriesList.firstIndex(where: { $0.countryInfo?.name == name }) {
            CountryLists.countriesList[i].isSaved = !CountryLists.countriesList[i].isSaved
            CountryLists.savedCountriesList = CountryLists.countriesList.filter({$0.isSaved == true})
            savedCountriesTableView.reloadData()
        }
    }
}
