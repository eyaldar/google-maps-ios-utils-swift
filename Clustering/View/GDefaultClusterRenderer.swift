//
//  GDefaultClusterRenderer.swift
//  google-maps-ios-utils-swift
//
//  Created by Eyal Darshan on 24/05/2016.
//  Copyright © 2016 eyaldar. All rights reserved.
//

import Foundation
import GoogleMaps

class GDefaultClusterRenderer: GClusterRenderer {
    private let _mapView: GMSMapView
    private var _markerCache: [GMSMarker]
    
    init(mapView: GMSMapView) {
        _mapView = mapView
        _markerCache = []
    }
    
    func clustersChanged(clusters: NSSet) {
        for marker in _markerCache {
            marker.map = nil
        }
        
        _markerCache.removeAll()
        
        for cluster in clusters {
            guard let `cluster` = cluster as? GCluster else {
                continue
            }
            
            let marker = GMSMarker()
            _markerCache.append(marker)
            
            let count = cluster.items.count
            
            if count > 1 {
                marker.iconView = generateClusterIconWithCount(count)
            } else {
                marker.icon = cluster.marker.icon
            }
            
            marker.userData = cluster.marker.userData
            marker.position = cluster.marker.position
            marker.map = _mapView
        }
    }
    
    func generateClusterIconWithCount(count: Int) -> UIView {
        return GDefaultClusterMarkerIconView(count: count)
    }
}
