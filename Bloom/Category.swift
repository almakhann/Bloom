//
//  Category.swift
//  Bloom
//
//  Created by Vadim on 25.06.17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit

class Category: NSObject {
    var name: String
    var imageName: String
    var id: Int
    var children: [Category] = []
    var parent: [Category] = []
    
    init(name: String, imageName: String, id: Int) {
        self.name = name
        self.imageName = imageName
        self.id = id
    }
}
