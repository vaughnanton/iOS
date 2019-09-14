//
//  Capital.swift
//  016capitalCities
//
//  Created by Vaughn on 8/28/19.
//  Copyright © 2019 Vaughn Anton. All rights reserved.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
