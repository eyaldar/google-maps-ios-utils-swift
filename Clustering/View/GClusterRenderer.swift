//
//  GClusterRenderer.swift
//  google-maps-ios-utils-swift
//
//  Created by Eyal Darshan on 24/05/2016.
//  Copyright © 2016 eyaldar. All rights reserved.
//

import Foundation
import GoogleMaps

protocol GClusterRenderer {
    func clustersChanged(clusters: NSSet)
}
