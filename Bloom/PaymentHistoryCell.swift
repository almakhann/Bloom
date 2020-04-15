//
//  PaymentHistoryCell.swift
//  Bloom
//
//  Created by Жарас on 29.06.17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit

class PaymentHistoryCell: UITableViewCell {
    
    @IBOutlet weak var dateOfPayment: UILabel!
    @IBOutlet weak var amountOfPayment: UILabel!
    @IBOutlet weak var paymentNumber: UILabel!
    
    
    @IBOutlet var labelsCollection: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
