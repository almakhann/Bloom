//
//  AdminOrdersTableViewCell.swift
//  Bloom
//
//  Created by Nassyrkhan Seitzhapparuly on 6/21/17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit

class AdminOrdersTableViewCell: UITableViewCell {

    @IBOutlet weak var orderTime: UILabel!
    @IBOutlet weak var salonName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        orderTime.textColor = UIColor(hex: "026C61")
        salonName.textColor = UIColor(hex: "636262")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
