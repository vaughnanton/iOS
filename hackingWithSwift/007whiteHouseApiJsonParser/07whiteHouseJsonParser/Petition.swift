//
//  Petition.swift
//  07whiteHouseJsonParser
//
//  Created by Vaughn on 6/14/19.
//  Copyright © 2019 Vaughn Anton. All rights reserved.
//

import Foundation

// structs give us a memberwise initializer, a special function that can create a new Petition by passing in title/body/signatureCount values
// make it conform to 'Codable' which is Swift's way of interacting with JSON
struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
