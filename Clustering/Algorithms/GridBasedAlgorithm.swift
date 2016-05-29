//
//  GridBasedAlgorithm.swift
//  google-maps-ios-utils-swift
//
//  Created by Eyal Darshan on 24/05/2016.
//  Copyright © 2016 eyaldar. All rights reserved.
//

import CoreLocation
import Foundation

final class GridBasedAlgorithm: ZoomDependentAlgorithm {
    let GRID_SIZE = 100.0
    
    override func getClusters(zoom: Double) -> NSSet {
        let numCells =  ceil(256.0 * pow(2, zoom) / GRID_SIZE)
        let proj = SphericalMercatorProjection(worldWidth: numCells)
        
        var clusters = [Double: GStaticCluster]()
        
        for item in items {
            if item.hidden {
                continue
            }
            
            let point = proj.coordinateToPoint(item.position)
            let coord = getCoord(numCells, x: point.x, y: point.y)
            
            if let cluster = clusters[coord] {
                cluster.add(item)
            } else {
                let cluster = GStaticCluster(coordinate: item.position)
                cluster.add(item)
                clusters[coord] = cluster
            }
        }
        
        let results = NSMutableSet()
        
        for cluster in clusters.values {
            results.addObject(cluster)
        }
        
        return results
    }
    
    private func getCoord(numCells: Double, x: Double, y: Double) -> Double{
        return floor(numCells * floor(x) + floor(y))
    }
}
