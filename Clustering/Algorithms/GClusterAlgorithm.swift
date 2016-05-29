//
//  GClusterAlgorithm.swift
//  google-maps-ios-utils-swift
//
//  Created by Eyal Darshan on 24/05/2016.
//  Copyright © 2016 eyaldar. All rights reserved.
//

import Foundation
import GoogleMaps
import UIKit

protocol GClusterAlgorithm {
    func addItem(item: GClusterItem)
    func removeItems()
    func removeItemsNotInRectangle(bounds: GQTBounds)
    func hideItemsNotInBounds(bounds: GMSCoordinateBounds)
    
    func removeItem(item: GClusterItem)
    func removeClusterItemsInSet(set: NSSet)
    func containsItem(item: GClusterItem) -> Bool
    func getClusters(zoom: Double) -> NSSet
}
