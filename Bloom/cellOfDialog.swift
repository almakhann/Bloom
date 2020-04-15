//
//  cellOfDialog.swift
//  Bloom
//
//  Created by Жарас on 25.04.17.
//  Copyright © 2017 zharas. All rights reserved.
//

import UIKit

class cellOfDialog: UITableViewCell {
    
    @IBOutlet weak var nameOfPartner: UILabel!
    
    @IBOutlet weak var lastMessage: UILabel!
    
    @IBOutlet weak var lastTime: UILabel!
    
    @IBOutlet weak var buttonOfServices: UIButton!
    
    func setTimeOfLastSended(UTCtime: String){
        
        lastTime.text = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        if let date = dateFormatter.date(from: UTCtime){
            if Calendar.current.isDateInToday(date){
                dateFormatter.dateFormat = "HH:mm"
            }else{
                dateFormatter.dateFormat = "MMM d"
            }
            dateFormatter.timeZone = TimeZone.current
            lastTime.text = dateFormatter.string(from: date)
        }
    }
    
    
    override func awakeFromNib() {
        self.selectionStyle = .none
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
