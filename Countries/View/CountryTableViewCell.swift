//
//  CountryTableViewCell.swift
//  Countries
//
//  Created by Elif Kasapoglu on 2.07.2022.
//

import UIKit

protocol SaveImageDelegate{
    func didSaveImageTapped(country: CountryItem?)
}

class CountryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var saveImage: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    
    var country: CountryItem?
    var delegate: SaveImageDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.cornerRadius = 10
        cellView.layer.borderWidth = 2
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        saveImage.isUserInteractionEnabled = true
        saveImage.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        delegate?.didSaveImageTapped(country: country)
    }
}
