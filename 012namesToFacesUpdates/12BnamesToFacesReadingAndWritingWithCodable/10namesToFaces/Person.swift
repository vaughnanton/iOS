//
//  Person.swift
//  10namesToFaces
//
//  Created by Vaughn on 7/12/19.
//  Copyright © 2019 Vaughn Anton. All rights reserved.
//

import UIKit

// this class will hold some data of our app, here we'll create an array of "people"
// goal is so that every time a picture is imported, we can create a Person object for it and add it to an array to be shown in the collection view

// NSObject is a universal base class
class Person: NSObject, Codable {

    var name: String
    var image: String
    
    // since String above is not ? or !, can't be nil - so we initialize them so they have a value
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
}
