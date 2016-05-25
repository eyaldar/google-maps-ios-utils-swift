//
//  GClusterItem.swift
//  google-maps-ios-utils-swift
//
//  Created by Eyal Darshan on 24/05/2016.
//  Copyright © 2016 eyaldar. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps

protocol GClusterItem: class, NSObjectProtocol {
    var position: CLLocationCoordinate2D { get }
    var marker: GMSMarker { get set }
}