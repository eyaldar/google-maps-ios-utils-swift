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
    private var _previousCameraPosition: GMSCameraPosition?
    weak var delegate: GMSMapViewDelegate?
    
    var isZoomDependent: Bool = false
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
    
    func removeItemsNotInRectangle(bounds: GQTBounds) {
        clusterAlgorithm.removeItemsNotInRectangle(bounds)
    }
    
    func hideItemsNotInBounds(bounds: GMSCoordinateBounds) {
        clusterAlgorithm.hideItemsNotInBounds(bounds)
    }
    
    func cluster() {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        let zoom = Double(mapView.camera.zoom)
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) { [unowned self] in
            let clusters = self.clusterAlgorithm.getClusters(zoom)
            
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                self.clusterRenderer.clustersChanged(clusters)
            }
        }
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
        
        if isZoomDependent {
            let visibleRegion = mapView.projection.visibleRegion()
            let gmsBounds = GMSCoordinateBounds(region: visibleRegion)
            
            self.hideItemsNotInBounds(gmsBounds)
        }
        
        // Don't recompute clusters if the map has just been panned/tilted/rotated.
        let pos = mapView.camera
        
        if _previousCameraPosition?.target.latitude == pos.target.latitude &&
           _previousCameraPosition?.target.longitude == pos.target.longitude {
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
    
    func mapView(mapView: GMSMapView, didCloseInfoWindowOfMarker marker: GMSMarker) {
        delegate?.mapView?(mapView, didCloseInfoWindowOfMarker: marker)
    }
    
    func mapView(mapView: GMSMapView, didBeginDraggingMarker marker: GMSMarker) {
        delegate?.mapView?(mapView, didBeginDraggingMarker: marker)
    }
    
    func mapView(mapView: GMSMapView, didLongPressInfoWindowOfMarker marker: GMSMarker) {
        delegate?.mapView?(mapView, didLongPressInfoWindowOfMarker: marker)
    }
    
    func mapView(mapView: GMSMapView, didLongPressAtCoordinate coordinate: CLLocationCoordinate2D) {
        delegate?.mapView?(mapView, didLongPressAtCoordinate: coordinate)
    }
    
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        if let result = delegate?.mapView?(mapView, didTapMarker: marker) {
            return result
        }
        
        return false
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