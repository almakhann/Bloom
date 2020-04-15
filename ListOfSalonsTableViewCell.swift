//
//  ListOfSalonsTableViewCell.swift
//  Bloom
//
//  Created by Nassyrkhan Seitzhapparuly on 6/12/17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit

class ListOfSalonsTableViewCell: UITableViewCell {
    
    let checkColor = UIColor(hex: "C2A162")
    let labelsColor = UIColor(hex: "686868")

    @IBOutlet weak var distanceImage: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var streetImage: UIImageView!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var checkMarkImage: UIImageView!
    @IBOutlet weak var nameOfSalonLabel: UILabel!
    
    @IBOutlet weak var firstStar: UIImageView!
    @IBOutlet weak var secondStar: UIImageView!
    @IBOutlet weak var thirdStar: UIImageView!
    @IBOutlet weak var fourthStar: UIImageView!
    @IBOutlet weak var fifthStar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        checkMarkImage.backgroundColor = checkColor
        distanceLabel.textColor = labelsColor
        streetLabel.textColor = labelsColor
        nameOfSalonLabel.textColor = labelsColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
