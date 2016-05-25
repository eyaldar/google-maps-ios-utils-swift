//
//  GQuadItem.swift
//  google-maps-ios-utils-swift
//
//  Created by Eyal Darshan on 24/05/2016.
//  Copyright © 2016 eyaldar. All rights reserved.
//

import CoreLocation
import Foundation
import GoogleMaps

class GQuadItem: NSObject, GCluster, GQTPointQuadTreeItem, NSCopying {
    private var _item: GClusterItem
    private var _point: GQTPoint
    private var _pointClass: QuadItemPoint
    private var _position: CLLocationCoordinate2D
    
    /**
     * Controls whether this marker will be shown on map.
     */
    var hidden: Bool = false
    
    var items: NSSet {
        return NSSet(object: _item)
    }
    
    var position: CLLocationCoordinate2D {
        return _position
    }
    
    var point: GQTPoint {
        return _point
    }
    
    init(clusterItem: GClusterItem) {
        let projection = SphericalMercatorProjection(worldWidth: 1.0)
        
        _position = clusterItem.position
        _point = projection.coordinateToPoint(_position)
        _pointClass = QuadItemPoint(x: _point.x, y: _point.y)
        _item = clusterItem
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let newGQuadItem = GQuadItem(clusterItem: _item)
        newGQuadItem._point = _point
        newGQuadItem._item = _item
        newGQuadItem._position = _position
        return newGQuadItem
    }
    
    func isEqual(quadItem other: GQuadItem) -> Bool {
        
        return _item.id == other._item.id &&
            _pointClass.x == other._pointClass.x &&
            _pointClass.y == other._pointClass.y
    }
    
    override func isEqual(other: AnyObject?) -> Bool {
        guard let `other` = other as? GQuadItem else {
            return false
        }
        
        return self.isEqual(quadItem: other)
    }
    
    override var hash: Int {
        return _item.hash
    }
}