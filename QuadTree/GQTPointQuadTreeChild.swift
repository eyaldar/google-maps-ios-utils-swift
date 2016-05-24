//
//  GQTPointQuadTreeChild.swift
//  google-maps-ios-utils-swift
//
//  Created by Eyal Darshan on 24/05/2016.
//  Copyright © 2016 eyaldar. All rights reserved.
//

import Foundation

class GQTPointQuadTreeChild: NSObject {
    
    let kMaxElements = 64
    let kMaxDepth = 30
    
    /** Top Right child quad. Nil until this node is split. */
    private var _topRight: GQTPointQuadTreeChild?
    /** Top Left child quad. Nil until this node is split. */
    private var _topLeft: GQTPointQuadTreeChild?
    /** Bottom Right child quad. Nil until this node is split. */
    private var _bottomRight: GQTPointQuadTreeChild?
    /** Bottom Left child quad. Nil until this node is split. */
    private var _bottomLeft: GQTPointQuadTreeChild?
    /**
    * Items in this PointQuadTree node, if this node has yet to be split. If we have items, children
    * will be nil, likewise, if we have children then items_ will be nil.
    */
    private var _items: [GQTPointQuadTreeItem]
    
    override init() {
        _items = []
    }
    
    /**
     * Insert an item into this PointQuadTreeChild
     *
     * @param item The item to insert. Must not be nil.
     * @param bounds The bounds of this node.
     * @param depth The depth of this node.
     */
    func add(item: GQTPointQuadTreeItem,
             withOwnBounds bounds: GQTBounds,
             atDepth depth: Int) {
        if _items.count > kMaxElements && depth < kMaxDepth {
            self.split(bounds, atDepth: depth)
        }
        
        if let `_topRight` = _topRight {
            let itemPoint = item.point
            let midPoint = bounds.midPoint
            
            if itemPoint.y > midPoint.y {
                if itemPoint.x > midPoint.x {
                    _topRight.add(item, withOwnBounds: GQTPointQuadTreeChild.boundsTopRightChildQuadBounds(bounds), atDepth: depth+1)
                } else {
                    _topLeft?.add(item, withOwnBounds: GQTPointQuadTreeChild.boundsTopLeftChildQuadBounds(bounds), atDepth: depth+1)
                }
            } else {
                if itemPoint.x > midPoint.x {
                    _bottomRight?.add(item, withOwnBounds: GQTPointQuadTreeChild.boundsBottomRightChildQuadBounds(bounds), atDepth: depth+1)
                } else {
                    _bottomLeft?.add(item, withOwnBounds: GQTPointQuadTreeChild.boundsBottomLeftChildQuadBounds(bounds), atDepth: depth+1)
                }
            }
        } else {
            _items.append(item)
        }
    }
    
    /**
     * Delete an item from this PointQuadTree.
     *
     * @param item The item to delete.
     * @param bounds The bounds of this node.
     * @return |false| if the items was not found in the tree, |true| otherwise.
     */
    func remove(item: GQTPointQuadTreeItem,
                withOwnBounds bounds: GQTBounds) -> Bool {
        if let `_topRight` = _topRight {
            let itemPoint = item.point
            let midPoint = bounds.midPoint
            
            if itemPoint.y > midPoint.y {
                if itemPoint.x > midPoint.x {
                    return _topRight.remove(item, withOwnBounds: GQTPointQuadTreeChild.boundsTopRightChildQuadBounds(bounds))
                } else {
                    return _topLeft!.remove(item, withOwnBounds: GQTPointQuadTreeChild.boundsTopLeftChildQuadBounds(bounds))
                }
            } else {
                if itemPoint.x > midPoint.x {
                    return _bottomRight!.remove(item, withOwnBounds: GQTPointQuadTreeChild.boundsBottomRightChildQuadBounds(bounds))
                } else {
                    return _bottomLeft!.remove(item, withOwnBounds: GQTPointQuadTreeChild.boundsBottomLeftChildQuadBounds(bounds))
                }
            }
        }
        
        if let index = _items.indexOf({ $0 == item }) {
            _items.removeAtIndex(index)
            return true
        }
        
        return false
    }
    
    /**
     * Retreive all items in this PointQuadTree within a bounding box.
     *
     * @param searchBounds The bounds of the search box.
     * @param ownBounds    The bounds of this node.
     * @return The results of the search.
     */
    func search(searchBounds: GQTBounds,
                ownBounds: GQTBounds) -> [GQTPointQuadTreeItem] {
        var results: [GQTPointQuadTreeItem]!
        
        if let `_topRight` = _topRight {
            let topRightBounds = GQTPointQuadTreeChild.boundsTopRightChildQuadBounds(ownBounds)
            let topLeftBounds = GQTPointQuadTreeChild.boundsTopLeftChildQuadBounds(ownBounds)
            let bottomRightBounds = GQTPointQuadTreeChild.boundsBottomRightChildQuadBounds(ownBounds)
            let bottomLeftBounds = GQTPointQuadTreeChild.boundsBottomLeftChildQuadBounds(ownBounds)
            
            if topRightBounds.intersectsWith(searchBounds) {
                results = _topRight.search(searchBounds, ownBounds: topRightBounds)
            }
            
            if topLeftBounds.intersectsWith(searchBounds) {
                results = _topLeft?.search(searchBounds, ownBounds: topRightBounds)
            }
            
            if bottomRightBounds.intersectsWith(searchBounds) {
                results = _bottomRight?.search(searchBounds, ownBounds: topRightBounds)
            }
            
            if bottomLeftBounds.intersectsWith(searchBounds) {
                results = _bottomLeft?.search(searchBounds, ownBounds: topRightBounds)
            }
        } else {
            results = []
            
            for item in _items {
                let point = item.point
                
                if searchBounds.contains(point) {
                    results.append(item)
                }
            }
        }
        
        return results
    }
    
    /**
     * Split the contents of this Quad over four child quads.
     * @param ownBounds    The bounds of this node.
     * @return The results of the search.
     */
    func split(ownBounds: GQTBounds, atDepth depth: Int) {
        _topRight       = GQTPointQuadTreeChild()
        _topLeft        = GQTPointQuadTreeChild()
        _bottomRight    = GQTPointQuadTreeChild()
        _bottomLeft     = GQTPointQuadTreeChild()
        
        let items = self._items
        
        for item in items {
            self.add(item, withOwnBounds: ownBounds, atDepth: depth)
        }
    }
}

// MARK - Static functions

extension GQTPointQuadTreeChild {
    class func boundsTopRightChildQuadBounds(parentBounds: GQTBounds) -> GQTBounds {
        let midPoint = parentBounds.midPoint
        
        let minX = midPoint.x
        let minY = midPoint.y
        let maxX = parentBounds.maxX
        let maxY = parentBounds.maxY
        
        return GQTBounds(minX: minX, minY: minY, maxX: maxX, maxY: maxY)
    }
    
    class func boundsTopLeftChildQuadBounds(parentBounds: GQTBounds) -> GQTBounds {
        let midPoint = parentBounds.midPoint
        
        let minX = parentBounds.minX
        let minY = midPoint.y
        let maxX = midPoint.x
        let maxY = parentBounds.maxY
        
        return GQTBounds(minX: minX, minY: minY, maxX: maxX, maxY: maxY)
    }
    
    class func boundsBottomRightChildQuadBounds(parentBounds: GQTBounds) -> GQTBounds {
        let midPoint = parentBounds.midPoint
        
        let minX = midPoint.x
        let minY = parentBounds.minY
        let maxX = parentBounds.maxY
        let maxY = midPoint.y
        
        return GQTBounds(minX: minX, minY: minY, maxX: maxX, maxY: maxY)
    }
    
    class func boundsBottomLeftChildQuadBounds(parentBounds: GQTBounds) -> GQTBounds {
        let midPoint = parentBounds.midPoint
        
        let minX = parentBounds.minX
        let minY = parentBounds.minY
        let maxX = midPoint.x
        let maxY = midPoint.y
        
        return GQTBounds(minX: minX, minY: minY, maxX: maxX, maxY: maxY)
    }
}