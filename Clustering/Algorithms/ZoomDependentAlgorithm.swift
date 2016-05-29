//
//  VisibleAreaOnlyAlgorithm.swift
//  google-maps-ios-utils-swift
//
//  Created by Eyal Darshan on 29/05/2016.
//  Copyright © 2016 eyaldar. All rights reserved.
//

import Foundation
import GoogleMaps

class ZoomDependentAlgorithm: GClusterAlgorithm {
    var _quadTree: GQTPointQuadTree
    private var _items: Array<GQuadItem>
    
    var items: Array<GQuadItem> {
        get {
            return _items
        }
    }
    
    init() {
        _items = []
        _quadTree = GQTPointQuadTree(bounds: GQTBounds(minX: 0, minY: 0, maxX: 1, maxY: 1))
    }
    
    func addItem(item: GClusterItem) {
        let quadItem = GQuadItem(clusterItem: item)
        _items.append(quadItem)
        _quadTree.add(quadItem)
    }
    
    func removeItems() {
        _items.removeAll()
        _quadTree.clear()
    }
    
    func removeItemsNotInRectangle(bounds: GQTBounds) {
        var newItems = Array<GQuadItem>()
        _quadTree.clear()
        
        for item in _items {
            if bounds.contains(GQTPoint(x: item.position.latitude, y: item.position.longitude)) {
                newItems.append(item)
                _quadTree.add(item)
            }
        }
        
        _items = newItems
    }
    
    func hideItemsNotInBounds(bounds: GMSCoordinateBounds) {
        for item in _items {
            item.hidden = !bounds.containsCoordinate(item.position)
        }
    }
    
    func removeItem(item: GClusterItem) {
        let set = NSSet(object: item)
        removeClusterItemsInSet(set)
    }
    
    func removeClusterItemsInSet(set: NSSet) {
        var toRemove = Array<GQuadItem>()
        
        for quadItem in _items {
            if set.containsObject(quadItem.item) {
                toRemove.append(quadItem)
            }
        }
        
        for quadItem in toRemove {
            if let index = _items.indexOf(quadItem) {
                _items.removeAtIndex(index)
            }
            
            _quadTree.remove(quadItem)
        }
    }
    
    func containsItem(item: GClusterItem) -> Bool {
        for quadItem in _items {
            if quadItem.item.id == item.id {
                return true
            }
        }
        
        return false
    }
    
    func getClusters(zoom: Double) -> NSSet {
        return NSSet()
    }
}
