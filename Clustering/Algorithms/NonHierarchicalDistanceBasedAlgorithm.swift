//
//  NonHierarchicalDistanceBasedAlgorithm.swift
//  google-maps-ios-utils-swift
//
//  Created by Eyal Darshan on 24/05/2016.
//  Copyright © 2016 eyaldar. All rights reserved.
//

import Foundation
import GoogleMaps

final class NonHierarchicalDistanceBasedAlgorithm: GClusterAlgorithm {
    private var _quadTree: GQTPointQuadTree
    private var _maxDistanceAtZoom: Int
    
    var _items: Array<GQuadItem>
    var _visibleItems: Array<GQuadItem>
    
    var items: Array<GQuadItem> {
        get {
            return _items
        }
    }
    
    var visibleItems: Array<GQuadItem> {
        get {
            return _visibleItems
        }
    }
    
    init(maxDistanceAtZoom: Int) {
        _items = []
        _visibleItems = []
        _quadTree = GQTPointQuadTree(bounds: GQTBounds(minX: 0, minY: 0, maxX: 1, maxY: 1))
        _maxDistanceAtZoom = maxDistanceAtZoom
    }
    
    convenience init() {
        self.init(maxDistanceAtZoom: 50)
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
    
    func removeItemsNotInBounds(bounds: GQTBounds) {
        _quadTree.clear()
        _visibleItems.removeAll()
        
        for item in _items {
            if bounds.contains(GQTPoint(x: item.position.latitude, y: item.position.longitude)) {
                _visibleItems.append(item)
                _quadTree.add(item)
            }
        }
    }
    
    func getClusters(zoom: Double) -> NSSet {
        let zoomSpecificSpan = Double(_maxDistanceAtZoom) / pow(2.0, zoom) / 256.0
        
        let visitedCandidates = NSMutableSet()
        let results = NSMutableSet()
        var distanceToCluster = Dictionary<GQuadItem, Double>()
        var itemToCluster = Dictionary<GQuadItem, GStaticCluster>()
        
        for candidate in _visibleItems {
            if candidate.hidden || visitedCandidates.containsObject(candidate) {
                // Candidate is hidden or already part of another cluster.
                continue
            }
        
            let bounds = createBoundsFromSpan(candidate.point, span: zoomSpecificSpan)
            let clusterItems = _quadTree.search(bounds)
            
            if clusterItems.count == 1 {
                // Only the current marker is in range. Just add the single item to the results
                results.addObject(candidate)
                visitedCandidates.addObject(candidate)
                distanceToCluster[candidate] = 0.0
                
                continue
            }
            
            let cluster = GStaticCluster(coordinate: candidate.position, marker: candidate.marker)
            results.addObject(cluster)
            
            for clusterItem in clusterItems {
                guard let `clusterItem` = clusterItem as? GQuadItem where !clusterItem.hidden else {
                    continue
                }
                
                let distance = distanceSquared(clusterItem.point, b: candidate.point)
                
                if let existingDistance = distanceToCluster[clusterItem] {
                    
                    // Item already belongs to another cluster. Check if it's closer to this cluster
                    if existingDistance < distance {
                        continue
                    }
                    
                    // Move item to the closer cluster
                    if let oldCluster = itemToCluster[clusterItem] {
                        oldCluster.remove(clusterItem)
                    }
                }
                
                distanceToCluster[clusterItem] = distance
                cluster.add(clusterItem)
                itemToCluster[clusterItem] = cluster
            }
            
            visitedCandidates.addObjectsFromArray(clusterItems as [AnyObject])
        }
        
        return results
    }
    
    func distanceSquared(a: GQTPoint, b: GQTPoint) -> Double {
        return (a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y)
    }
    
    func createBoundsFromSpan(point: GQTPoint, span: Double) -> GQTBounds {
        let halfSpan = span / 2
        
        return GQTBounds(minX: point.x - halfSpan,
                         minY: point.y - halfSpan,
                         maxX: point.x + halfSpan,
                         maxY: point.y + halfSpan)
    }
}
