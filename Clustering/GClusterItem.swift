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

protocol GClusterItem: NSObjectProtocol {
    var id: String { get }
    var position: CLLocationCoordinate2D { get }
}