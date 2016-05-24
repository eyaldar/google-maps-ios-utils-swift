//
//  GStaticCluster.swift
//  google-maps-ios-utils-swift
//
//  Created by Eyal Darshan on 24/05/2016.
//  Copyright © 2016 eyaldar. All rights reserved.
//

import CoreLocation
import Foundation
import GoogleMaps

class GStaticCluster: GCluster {
    private var _position: CLLocationCoordinate2D
    private var _items: Set<GQuadItem>
    private var _marker: GMSMarker
    
    var marker: GMSMarker {
        get {
            return _marker
        }
        set {
            _marker = newValue
        }
    }
    
    var items: NSSet {
        return _items
    }
    
    var position: CLLocationCoordinate2D {
        return _position
    }
    
    init(coordinate: CLLocationCoordinate2D, marker: GMSMarker) {
        _position = coordinate
        _items = Set<GQuadItem>()
        _marker = marker
    }
    
    func add(item: GQuadItem) {
        _items.insert(item)
    }
    
    func remove(item: GQuadItem) {
        _items.remove(item)
    }
    
}
