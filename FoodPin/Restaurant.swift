//
//  Restaurant.swift
//  FoodPin
//
//  Created by Piotr Wesołowski on 18/12/16.
//  Copyright © 2016 Piotr Wesołowski. All rights reserved.
//

import Foundation

class Restaurant {
    var name = ""
    var location = ""
    var type = ""
    var image = ""
    var isVisited = false
    var phoneNumber = ""
    var rating = ""
    
    init(name: String, location: String, type: String, image: String, isVisited: Bool, phoneNumber: String) {
        self.name = name
        self.location = location
        self.type = type
        self.image = image
        self.isVisited = isVisited
        self.phoneNumber = phoneNumber
    }
}
