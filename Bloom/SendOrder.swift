//
//  Order.swift
//  Bloom
//
//  Created by Vadim on 25.06.17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit

class SendOrder: NSObject {
    var radius: Int //id подзаказов (от одного человека разные подзаказы)
    var features: [Features] = []
    var locationX: String //feature id
    var locationY: String //id общих заказов от людей
    var time: String

    init(radius: Int, locationX: String, locationY: String, time: String) {
        self.radius = radius
        self.locationX = locationX
        self.locationY = locationY
        self.time = time
    }
    
    override init() {
        self.radius = 0
        self.locationX = ""
        self.locationY = ""
        self.time = ""
    }
}

class Features: NSObject {
    
    var feature: Int //feature id
    var price: Int
    
    init(feature: Int, price: Int) {
        self.feature = feature
        self.price = price
    }
}
