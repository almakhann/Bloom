//
//  AdminTimesTableViewCell.swift
//  Bloom
//
//  Created by Nassyrkhan Seitzhapparuly on 6/22/17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit

class AdminTimesTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        timeLabel.textColor = UIColor(hex: "929292")
        timeLabel.font = UIFont(name: "Comfortaa-Regular", size: 20)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
