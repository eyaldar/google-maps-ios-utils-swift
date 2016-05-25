//
//  GDefaultClusterRenderer.swift
//  google-maps-ios-utils-swift
//
//  Created by Eyal Darshan on 24/05/2016.
//  Copyright © 2016 eyaldar. All rights reserved.
//

import Foundation
import GoogleMaps

final class GDefaultClusterRenderer: GClusterRenderer {
    private let _mapView: GMSMapView
    private var _markerCache: [GMSMarker]
    private var _nonClusterMarkerCache: [GMSMarker]
    private var _markerStack: Stack<GMSMarker>
    
    init(mapView: GMSMapView) {
        _mapView = mapView
        _markerCache = []
        _nonClusterMarkerCache = []
        _markerStack = Stack<GMSMarker>()
    }
    
    func clustersChanged(clusters: NSSet) {
        for marker in _markerCache {
            marker.map = nil
            _markerStack.push(marker)
        }
        
        clearCaches()
        
        for cluster in clusters {
            guard let `cluster` = cluster as? GCluster else {
                continue
            }
            
            var marker: GMSMarker!
            let count = cluster.items.count
            
            if count > 1 {
                marker = getMarker()
                createOrUpdateIconView(marker, count: count)
                _markerCache.append(marker)
            } else {
                marker = cluster.marker
                _nonClusterMarkerCache.append(cluster.marker)
            }
            
            marker.title = cluster.marker.title
            marker.appearAnimation = kGMSMarkerAnimationPop
            marker.position = cluster.marker.position
            marker.tracksViewChanges = false
            marker.map = _mapView
        }
    }
    
    private func generateClusterIconWithCount(count: Int) -> UIView {
        return GDefaultClusterMarkerIconView(count: count)
    }
    
    private func getMarker() -> GMSMarker {
        var marker: GMSMarker!
        
        if let recycledMarker = _markerStack.pop() {
            marker = recycledMarker
        } else {
            marker = GMSMarker()
        }
        
        return marker
    }
    
    private func createOrUpdateIconView(marker: GMSMarker, count: Int) {
        if let iconView = marker.iconView as? GDefaultClusterMarkerIconView {
            iconView.update(count)
        } else {
            marker.iconView = generateClusterIconWithCount(count)
        }
    }
    
    private func clearCaches() {
        for marker in _markerCache {
            marker.map = nil
            
            _markerStack.push(marker)
        }
        
        _markerCache.removeAll()
        
        for marker in _nonClusterMarkerCache {
            marker.map = nil
        }
        
        _nonClusterMarkerCache.removeAll()
    }
}
