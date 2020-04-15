//
//  faqCell.swift
//  Bloom
//
//  Created by Serik on 04.06.17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit

class faqCell: UITableViewCell {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
