//
//  ServiceCell.swift
//  Bloom
//
//  Created by Жарас on 22.06.17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit

class ServiceCell: UITableViewCell {

    @IBOutlet weak var imageOfService: UIImageView!
    @IBOutlet weak var nameOfService: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
