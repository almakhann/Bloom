//
//  Feedback.swift
//  Bloom
//
//  Created by Жарас on 29.06.17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import Foundation

class Feedback{
    var context: String = String()
    var date: String = String()
    var owner: String = String()
    
    init(text: String, date: String, owner: String){
        self.context = text
        self.date = date
        self.owner = owner
    }
    
}
