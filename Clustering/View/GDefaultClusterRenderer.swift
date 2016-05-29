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
    private var _markerStack: Stack<GMSMarker>
    
    init(mapView: GMSMapView) {
        _mapView = mapView
        _markerCache = []
        _markerStack = Stack<GMSMarker>()
    }
    
    func clustersChanged(clusters: NSSet) {
        clearCaches()
        
        for cluster in clusters {
            guard let `cluster` = cluster as? GCluster else {
                continue
            }
            
            let marker = getMarker()
            _markerCache.append(marker)
            
            let count = cluster.items.count
            
            if count > 1 {
                createOrUpdateIconView(marker, count: count)
            } else if count == 1 {
                marker.iconView = UIImageView(image: GMSMarker.markerImageWithColor(UIColor ( red: 0.5107, green: 0.0896, blue: 0.0953, alpha: 1.0 )))
            }
            
            marker.position = cluster.position
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
            marker.iconView = iconView
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
    }
}
