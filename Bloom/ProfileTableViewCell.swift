//
//  ProfileTableViewCell.swift
//  Bloom
//
//  Created by Nassyrkhan Seitzhapparuly on 6/13/17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    let nameColor = UIColor(hex: "C2A162")
    let dateColor = UIColor(hex: "026C61")
    let commentColor = UIColor(hex: "686868")
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var topMargin: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        name.textColor = nameColor
        date.textColor = dateColor
        comment.textColor = commentColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
