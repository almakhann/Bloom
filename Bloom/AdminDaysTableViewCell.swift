//
//  AdminDaysTableViewCell.swift
//  Bloom
//
//  Created by Nassyrkhan Seitzhapparuly on 6/21/17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit

class AdminDaysTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var countOfOrder: UILabel!
    @IBOutlet weak var selectedView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dayLabel.textColor = UIColor(hex: "929292")
        dayLabel.font = UIFont(name: "Comfortaa-Regular", size: 14)
        countOfOrder.font = UIFont(name: "Comfortaa-Regular", size: 10)
        countOfOrder.layer.masksToBounds = true
        countOfOrder.layer.cornerRadius = 6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
