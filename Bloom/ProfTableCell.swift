//
//  ProfTableCell.swift
//  Bloom
//
//  Created by Nassyrkhan Seitzhapparuly on 6/19/17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit

class ProfTableCell: UITableViewCell {

    @IBOutlet weak var imageOfSalon: UIImageView!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var imageOfDistance: UIImageView!
    @IBOutlet weak var labelOfDistance: UILabel!
    @IBOutlet weak var imageOfStreet: UIImageView!
    @IBOutlet weak var labelOfStreet: UILabel!
    @IBOutlet weak var labelOfSalon: UILabel!
    @IBOutlet weak var imageOfPhone: UIImageView!
    @IBOutlet weak var labelOfPhone: UILabel!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var firstStar: UIImageView!
    @IBOutlet weak var secondStar: UIImageView!
    @IBOutlet weak var thirdStar: UIImageView!
    @IBOutlet weak var fourthStar: UIImageView!
    @IBOutlet weak var fifthStar: UIImageView!
    
    var starArray : [UIImageView] = []
    
    let yourAttributes : [String: Any] = [
        NSFontAttributeName : UIFont.systemFont(ofSize: 14),
        NSForegroundColorAttributeName : UIColor(hex: "C2A162"),
        NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageButton.backgroundColor = UIColor(hex: "009688")
        labelOfSalon.textColor = UIColor(hex: "C2A162")
        labelOfDistance.textColor = UIColor(hex: "686868")
        labelOfStreet.textColor = UIColor(hex: "686868")
        labelOfPhone.textColor = UIColor(hex: "686868")
        infoLabel.textColor = UIColor(hex: "686868")
        imageOfPhone.image = imageOfPhone.image?.withRenderingMode(.alwaysTemplate)
        imageOfPhone.tintColor = UIColor(hex: "026C61")
        
        let attributeString = NSMutableAttributedString(string: "Cмотреть услуги", attributes: yourAttributes)
        showButton.setAttributedTitle(attributeString, for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    @IBAction func showButtonPressed(_ sender: UIButton) {
        
    }
    
}
