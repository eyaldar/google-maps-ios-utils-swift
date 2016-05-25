//
//  GClusterManger.swift
//  google-maps-ios-utils-swift
//
//  Created by Eyal Darshan on 24/05/2016.
//  Copyright © 2016 eyaldar. All rights reserved.
//

import Foundation
import GoogleMaps
import UIKit

final class GClusterManger: NSObject {
    private var _currentClusterId = 0
    private var _previousCameraPosition: GMSCameraPosition?
    weak var delegate: GMSMapViewDelegate?
    
    var items: NSMutableArray?
    
    var mapView: GMSMapView {
        didSet {
            _previousCameraPosition = nil
        }
    }
    
    var clusterAlgorithm: GClusterAlgorithm {
        didSet {
            _previousCameraPosition = nil
        }
    }
    
    var clusterRenderer: GClusterRenderer {
        didSet {
            _previousCameraPosition = nil
        }
    }
    
    init(mapView: GMSMapView, algorithm: GClusterAlgorithm, renderer: GClusterRenderer) {
        self.mapView = mapView
        self.clusterAlgorithm = algorithm
        self.clusterRenderer = renderer
    }
    
    func addItem(item: GClusterItem) {
        clusterAlgorithm.addItem(item)
    }
    
    func removeItems() {
        clusterAlgorithm.removeItems()
    }
    
    func removeItemsNotInBounds(bounds: GQTBounds) {
        clusterAlgorithm.removeItemsNotInBounds(bounds)
    }
    
    func cluster() {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        let zoom = Double(mapView.camera.zoom)
        let visibleBounds = translateMapViewVisibleBoundsToGQTBounds()
        _currentClusterId += 1
        let clusterId = _currentClusterId
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) { [unowned self] in
            self.removeItemsNotInBounds(visibleBounds)
            let clusters = self.clusterAlgorithm.getClusters(zoom)
            
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                if clusterId == self._currentClusterId {
                    self.clusterRenderer.clustersChanged(clusters)
                }
            }
        }
    }
    
    private func gmsBoundsToGQTBounds(gmsBounds: GMSCoordinateBounds) -> GQTBounds {
        let minLat = gmsBounds.southWest.latitude
        let minLong = gmsBounds.southWest.longitude
        let maxLat = gmsBounds.northEast.latitude
        let maxLong = gmsBounds.northEast.longitude
        
        return GQTBounds(minX: minLat, minY: minLong, maxX: maxLat, maxY: maxLong)
    }
    
    private func translateMapViewVisibleBoundsToGQTBounds() -> GQTBounds {
        let visibleRegion = mapView.projection.visibleRegion()
        let gmsBounds = GMSCoordinateBounds(region: visibleRegion)
        let visibleBounds = gmsBoundsToGQTBounds(gmsBounds)
        
        return visibleBounds
    }
}

extension GClusterManger: GMSMapViewDelegate {
    func mapView(mapView: GMSMapView, willMove gesture: Bool) {
        delegate?.mapView?(mapView, willMove: gesture)
    }
    
    func mapView(mapView: GMSMapView, didChangeCameraPosition position: GMSCameraPosition) {
        delegate?.mapView?(mapView, didChangeCameraPosition: position)
    }
    
    func mapView(mapView: GMSMapView, idleAtCameraPosition position: GMSCameraPosition) {
        assert(mapView == self.mapView)
        
        // Don't recompute clusters if the map has just been panned/tilted/rotated.
        let pos = mapView.camera
        if let previousCameraPosition = _previousCameraPosition where previousCameraPosition.zoom == pos.zoom {
            if delegate != nil {
                delegate?.mapView?(mapView, idleAtCameraPosition: position)
                return
            }
        }
        
        _previousCameraPosition = mapView.camera
        
        self.cluster()
        
        delegate?.mapView?(mapView, idleAtCameraPosition: position)
    }
    
    func mapView(mapView: GMSMapView, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        delegate?.mapView?(mapView, didTapAtCoordinate: coordinate)
    }
    
    func mapView(mapView: GMSMapView, didLongPressAtCoordinate coordinate: CLLocationCoordinate2D) {
        delegate?.mapView?(mapView, didLongPressAtCoordinate: coordinate)
    }
    
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        if let result = delegate?.mapView?(mapView, didTapMarker: marker) {
            return result
        }
        
        return true
    }
    
    func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker) {
        delegate?.mapView?(mapView, didTapInfoWindowOfMarker: marker)
    }
    
    func mapView(mapView: GMSMapView, didTapOverlay overlay: GMSOverlay) {
        delegate?.mapView?(mapView, didTapOverlay: overlay)
    }
    
    func mapView(mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        if let view = delegate?.mapView?(mapView, markerInfoWindow: marker) {
            return view
        }
        
        return nil
    }
    
    func mapView(mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        if let view = delegate?.mapView?(mapView, markerInfoContents: marker) {
            return view
        }
        
        return nil
    }
    
    func mapView(mapView: GMSMapView, didEndDraggingMarker marker: GMSMarker) {
        delegate?.mapView?(mapView, didEndDraggingMarker: marker)
    }
    
    func mapView(mapView: GMSMapView, didDragMarker marker: GMSMarker) {
        delegate?.mapView?(mapView, didDragMarker: marker)
    }
}