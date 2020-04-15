
//  CommentTableCell.swift
//  Bloom
//
//  Created by Nassyrkhan Seitzhapparuly on 6/19/17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit

class CommentTableCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var topMargin: NSLayoutConstraint!
    @IBOutlet weak var comment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        name.textColor = UIColor(hex: "C2A162")
        date.textColor = UIColor(hex: "026C61")
        comment.textColor = UIColor(hex: "686868")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
