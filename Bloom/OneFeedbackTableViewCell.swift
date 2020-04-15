//
//  OneFeedbackTableViewCell.swift
//  Bloom
//
//  Created by Жарас on 29.06.17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit

class OneFeedbackTableViewCell: UITableViewCell {

    @IBOutlet weak var owner: UILabel!
    @IBOutlet weak var dateOfFeedback: UILabel!
    @IBOutlet weak var contextOfFeedback: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
