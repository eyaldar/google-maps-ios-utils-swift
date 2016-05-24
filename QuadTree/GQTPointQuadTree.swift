//
//  GQTPointQuadTree.swift
//  google-maps-ios-utils-swift
//
//  Created by Eyal Darshan on 24/05/2016.
//  Copyright © 2016 eyaldar. All rights reserved.
//

import Foundation

class GQTPointQuadTree {
    private var _bounds: GQTBounds
    private var _root: GQTPointQuadTreeChild!
    private var _count: Int = 0
    
    /**
     * The number of items in this entire tree.
     *
     * @return The number of items.
     */
    var count: Int {
        return _count
    }
    
    /**
     * Create a QuadTree with the inclusive bounds of (-1,-1) to (1,1).
     */
    convenience init() {
        self.init(bounds: GQTBounds(minX: -1, minY: -1, maxX: 1, maxY: 1))
    }
    
    /**
     * Create a QuadTree with bounds. Please note, this class is not thread safe.
     *
     * @param bounds The bounds of this PointQuadTree. The tree will only accept items that fall
     within the bounds. The bounds are inclusive.
     */
    init(bounds: GQTBounds) {
        _bounds = bounds
        self.clear()
    }
    
    /**
     * Insert an item into this PointQuadTree.
     *
     * @param item The item to insert. Must not be nil.
     * @return |false| if the item is not contained within the bounds of this tree.
     *         Otherwise adds the item and returns |true|.
     */
    func add(item: GQTPointQuadTreeItem) -> Bool {
        let point = item.point
        
        guard _bounds.contains(point) else {
            return false
        }
        
        _root.add(item, withOwnBounds: _bounds, atDepth: 0)
        _count += 1
        
        return true
    }
    
    /**
     * Delete an item from this PointQuadTree.
     *
     * @param item The item to delete.
     * @return |false| if the items was not found in the tree, |true| otherwise.
     */
    func remove(item: GQTPointQuadTreeItem) -> Bool {
        let point = item.point
        
        guard _bounds.contains(point) else {
            return false
        }
        
        let wasRemoved = _root.remove(item, withOwnBounds: _bounds)
        
        if wasRemoved {
            _count -= 1
        }
        
        return wasRemoved
    }
    
    /**
     * Delete all items from this PointQuadTree.
     */
    func clear() {
        _root = GQTPointQuadTreeChild()
        _count = 0
    }
    
    /**
     * Retreive all items in this PointQuadTree within a bounding box.
     *
     * @param bounds The bounds of the search box.
     * @return The collection of items within |bounds|, returned as an Array
     *         of GQTPointQuadTreeItem.
     */
    func search(bounds: GQTBounds) -> NSArray {
        let results = _root.search(bounds, ownBounds: _bounds)
        return results
    }
}
