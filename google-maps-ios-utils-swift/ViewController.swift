//
//  ViewController.swift
//  google-maps-ios-utils-swift
//
//  Created by Eyal Darshan on 24/05/2016.
//  Copyright © 2016 eyaldar. All rights reserved.
//

import GoogleMaps
import UIKit

class ViewController: UIViewController {
    let kStartingLocation = CLLocationCoordinate2D(latitude: 51.503186, longitude: -0.126446)
    let kStartingZoom: Float = 9.5
    
    private var _mapView: GMSMapView!
    private var _clusterManager: GClusterManger!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cameraPosition = GMSCameraPosition.cameraWithTarget(kStartingLocation, zoom: kStartingZoom)
        
        _mapView = GMSMapView(frame: CGRectZero)
        _mapView.camera = cameraPosition
        _mapView.myLocationEnabled = true
        _mapView.settings.myLocationButton = true
        _mapView.settings.compassButton = true
        
        self.view = _mapView
        
        _clusterManager = GClusterManger(mapView: _mapView,
                                         algorithm: NonHierarchicalDistanceBasedAlgorithm(),
                                         renderer: GDefaultClusterRenderer(mapView: _mapView))
        
        _mapView.delegate = _clusterManager
        _clusterManager.delegate = self
        
        for _ in 0...5000 {
            let spot = generateSpot()
            _clusterManager.addItem(spot)
        }
        
        _clusterManager.cluster()
    }
    
    func generateSpot() -> Spot {
        let marker = GMSMarker()
        marker.title = "Test \(getRandomNumberBetween(1, max: 100))"
        marker.position = CLLocationCoordinate2D(latitude: getRandomNumberBetween(51.38494009999999, max:51.6723432),
                                                 longitude: getRandomNumberBetween(-0.3514683, max: 0.148271))
        
        let spot = Spot(marker: marker, position: marker.position)
        
        return spot
    }
    
    func getRandomNumberBetween(min: Double, max: Double) -> Double {
        return min + (max - min) * drand48()
    }
}

extension ViewController: GMSMapViewDelegate {
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        print("Marker Tapped!!")
        return true
    }
}

