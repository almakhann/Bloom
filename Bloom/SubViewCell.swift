//
//  SubViewCell.swift
//  Bloom
//
//  Created by Serik on 20.06.17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit

class SubViewCell: UITableViewCell {

    @IBOutlet var subViewView: UIView!
    @IBOutlet var subViewLabel: UILabel!
    
    var protocolOfVC: SelectTypesAndSubTypesVC? = nil
    var indexPathOfCell: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
}
