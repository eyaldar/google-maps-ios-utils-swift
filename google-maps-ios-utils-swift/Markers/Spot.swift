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
    var position: CLLocationCoordinate2D
    var marker: GMSMarker
    
    init(marker: GMSMarker, position: CLLocationCoordinate2D) {
        self.position = position
        self.marker = marker
    }
}
