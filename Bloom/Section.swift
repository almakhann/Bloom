//
//  Section.swift
//  Bloom
//
//  Created by Nassyrkhan Seitzhapparuly on 6/16/17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import Foundation
import UIKit

struct Order{
    var orderDate: String!
    var orderType: [Int]
    var orderName: [String]
    var orderPrice: [String]
    var orderTime: String!
    var salonName: String
    
    init(orderDate: String = String(), orderType: [Int] = [], orderName: [String] = [], orderPrice: [String] = [], orderTime: String = String(), salonName: String = String()) {
        self.orderDate = orderDate
        self.orderType = orderType
        self.orderName = orderName
        self.orderPrice = orderPrice
        self.orderTime = orderTime
        self.salonName = salonName
    }
}

struct OrderAdmin {
    var orderDate: String!
    var orderType: [Int]
    var orderName: [String]
    var orderPrice: [String]
    var orderTime: String!
    var userName: String!
    var userPhone: String!
    var requestID : Int!
    var responseID : Int!
    
    init(orderDate: String = String(), orderType: [Int] = [], orderName: [String] = [], orderPrice: [String] = [], orderTime: String = String(), userName: String = String(), userPhone: String = String(), requestID: Int = Int(), responseID: Int = Int()) {
        self.orderDate = orderDate
        self.orderType = orderType
        self.orderName = orderName
        self.orderPrice = orderPrice
        self.orderTime = orderTime
        self.userName = userName
        self.userPhone = userPhone
        self.requestID = requestID
        self.responseID = responseID
    }
}

struct OrderAdminCalendar {
    var orderDate: String!
    var orderType: [Int]
    var orderName: [String]
    var orderPrice: [String]
    var orderTime: String!
    var userName: String!
    var userPhone: String!
    
    init(orderDate: String = String(), orderType: [Int] = [], orderName: [String] = [], orderPrice: [String] = [], orderTime: String = String(), userName: String = String(), userPhone: String = String()) {
        self.orderDate = orderDate
        self.orderType = orderType
        self.orderName = orderName
        self.orderPrice = orderPrice
        self.orderTime = orderTime
        self.userName = userName
        self.userPhone = userPhone
    }
}

struct Salon {
    var salonName: String!
    var salonDistance: String!
    var salonAddress: String!
    var salonPhone: String!
    var salonDescription: String!
    var salonRating: Int!
    var salonPhoto: UIImage!
    var salonId: Int!
    
    init(salonName: String = String(), salonDistance: String = String(), salonAddress: String = String(), salonDescription: String = String(), salonRating: Int = Int(), salonId: Int = Int(), salonPhone: String = String()) {
        self.salonName = salonName
        self.salonDistance = salonDistance
        self.salonAddress = salonAddress
        self.salonDescription = salonDescription
        self.salonRating = salonRating
        self.salonId = salonId
    }
}

struct Service {
    var features: String!
    var types: [String]!
    var id: Int
    var expanded: Bool!
    
    init(features: String, types: [String], expanded: Bool, id: Int) {
        self.features = features
        self.types = types
        self.expanded = expanded
        self.id = id
    }
}

struct Comment{
    var name : String!
    var date : String!
    var comment : String!
    
    init(name: String = String(), date: String = String(), comment: String = String()) {
        self.name = name
        self.date = date
        self.comment = comment
    }
}
