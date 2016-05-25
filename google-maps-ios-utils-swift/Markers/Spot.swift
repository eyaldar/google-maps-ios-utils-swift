//
//  Spot.swift
//  google-maps-ios-utils-swift
//
//  Created by Eyal Darshan on 24/05/2016.
//  Copyright © 2016 eyaldar. All rights reserved.
//

import CoreLocation
import Foundation
import GoogleMaps

class Spot: NSObject, GClusterItem {
    let id: String
    var position: CLLocationCoordinate2D
    
    init(id: String, position: CLLocationCoordinate2D) {
        self.id = id
        self.position = position
    }
}
