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
class Person: NSObject, NSCoding {

    var name: String
    var image: String
    
    // since String above is not ? or !, can't be nil - so we initialize them so they have a value
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
    // the below two functions will conform Person class to NSCoding - now to load and save people array in view controller
    
    // used when loading objects of this class
    required init(coder aDecoder: NSCoder) {
        // use as? and ?? incase you can't invalid data
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        image = aDecoder.decodeObject(forKey: "image") as? String ?? ""
    }
    
    // used when saving
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(image, forKey: "image")
    }
    
}
