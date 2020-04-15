//
//  Marker.swift
//  Bloom
//
//  Created by Vadim on 27.06.17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit
import GoogleMaps


class Marker: NSObject {
    
    var marker: GMSMarker
    var status: Int
    var id: Int
    var salonDescription: String
    var salonName: String
    var salonRating: Int
    var salonAddress: String
    var distance: String
    var locationX: Double
    var locationY: Double
    
    init(marker: GMSMarker, status: Int, id: Int, salonDescription: String, salonName: String, salonRating: Int, salonAddress: String,  distance: String, locationX: Double, locationY: Double) {
        self.marker = marker
        self.status = status
        self.id = id
        self.salonDescription = salonDescription
        self.salonName = salonName
        self.salonRating = salonRating
        self.salonAddress = salonAddress
        self.distance = distance
        self.locationX = locationX
        self.locationY = locationY
    }
    
    override init() {
        self.marker = GMSMarker()
        self.status = 0
        self.id = 0
        self.salonDescription = ""
        self.salonName = ""
        self.salonRating = 0
        self.salonAddress = ""
        self.distance = ""
        self.locationX = 0
        self.locationY = 0
    }
    
}
