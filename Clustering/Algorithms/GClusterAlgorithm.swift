//
//  GClusterAlgorithm.swift
//  google-maps-ios-utils-swift
//
//  Created by Eyal Darshan on 24/05/2016.
//  Copyright © 2016 eyaldar. All rights reserved.
//

import Foundation
import UIKit

protocol GClusterAlgorithm {
    func addItem(item: GClusterItem)
    func removeItems()
    func removeItemsNotInBounds(bounds: GQTBounds)
    
    func getClusters(zoom: Double) -> NSSet
}
