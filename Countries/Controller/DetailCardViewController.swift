//
//  DetailCardViewController.swift
//  Countries
//
//  Created by Elif Kasapoglu on 3.07.2022.
//

import UIKit
import WebKit
import SVGKit

class DetailCardViewController: UIViewController {
    
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var country: CountryItem?
    fileprivate var countriesWebService = CountriesWebService()
    fileprivate var moreInfoUrl: String = "https://www.wikidata.org/wiki/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countriesWebService.delegate = self
        
        prepareNavigationRightBar()
        getInfo()
        setAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    fileprivate func setAppearance(){
        flagImageView.layer.borderWidth = 3
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        mainView.isHidden = true
    }
    
    fileprivate func getInfo(){
        if let info = country?.countryInfo{
            navigationItem.title = info.name
            countryCodeLabel.text = info.code
            countriesWebService.fetchDetails(countryCode: info.code)
        }
    }
    
    fileprivate func prepareNavigationRightBar(){
        let savedImage = country?.saveImage?.withRenderingMode(.automatic).withTintColor(.black)
        let savedButton = UIBarButtonItem(image: savedImage, style: .plain, target: self, action: #selector(savedButtonTapped))
        navigationItem.rightBarButtonItem = savedButton
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    @objc func savedButtonTapped(sender: UIBarButtonItem) {
        changeSavedIcon()
        refreshLists()
    }
    
    fileprivate func changeSavedIcon(){
        if let isSaved = country?.isSaved{
            country?.isSaved = !isSaved
            navigationItem.rightBarButtonItem?.image = country?.saveImage
        }
    }
    
    fileprivate func refreshLists(){
        if let name = country?.countryInfo?.name, let i =  CountryLists.countriesList.firstIndex(where: { $0.countryInfo?.name == name }) {
            CountryLists.countriesList[i].isSaved = !CountryLists.countriesList[i].isSaved
            CountryLists.savedCountriesList = CountryLists.countriesList.filter({$0.isSaved == true})
            
        }
    }
    
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        if let url = URL(string: moreInfoUrl) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}

//MARK: - Web Service Delegate Methods
extension DetailCardViewController: CountriesWebServiceDelegate{
    func didFetchDetails(details: DetailDataModel) {
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.main.async {
            if let svg = URL(string: details.data.flagImageUri){
                let data = try? Data(contentsOf: svg)
                let receivedimage: SVGKImage = SVGKImage(data: data)
                self.flagImageView.image = receivedimage.uiImage
            }
            self.moreInfoUrl = self.moreInfoUrl + details.data.wikiDataId
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.mainView.isHidden = false
            self.activityIndicator.stopAnimating()
        }
    }
}
