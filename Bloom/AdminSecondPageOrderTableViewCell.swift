//
//  AdminSecondPageOrderTableViewCell.swift
//  Bloom
//
//  Created by Nassyrkhan Seitzhapparuly on 6/22/17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit

class AdminSecondPageOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var nameAndPhoneLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameAndPhoneLabel.textColor = UIColor(hex: "636262")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
