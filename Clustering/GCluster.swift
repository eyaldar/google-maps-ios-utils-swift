//
//  GCluster.swift
//  google-maps-ios-utils-swift
//
//  Created by Eyal Darshan on 24/05/2016.
//  Copyright © 2016 eyaldar. All rights reserved.
//

import CoreLocation
import Foundation

protocol GCluster {
    var position: CLLocationCoordinate2D { get }
    var items: NSSet { get }
}