//
//  GQTPoint.swift
//  google-maps-ios-utils-swift
//
//  Created by Eyal Darshan on 24/05/2016.
//  Copyright © 2016 eyaldar. All rights reserved.
//

struct GQTBounds {
    let minX: Double
    let minY: Double
    let maxX: Double
    let maxY: Double
    
    var midPoint: GQTPoint {
        return GQTPoint(x: (minX + maxX) / 2, y: (minY + maxY) / 2)
    }
    
    var width: Double {
        return maxX - minX
    }
    
    var height: Double {
        return maxY - minY
    }
    
    func intersectsWith(other: GQTBounds) -> Bool {
        let myMidPoint = midPoint
        let otherMidPoint = other.midPoint
        
        let intersectsX = abs(myMidPoint.x - otherMidPoint.x) * 2 < (width + other.width)
        let intersectsY = abs(myMidPoint.y - otherMidPoint.y) * 2 < (height + other.height)
        
        return intersectsX && intersectsY
    }
    
    func contains(point: GQTPoint) -> Bool {
        let containsX = minX <= point.x && point.x <= maxX
        let containsY = minY <= point.y && point.y <= maxY
        
        return containsX && containsY
    }
}
