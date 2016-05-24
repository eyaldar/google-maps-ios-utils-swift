//
//  GQTPointQuadTreeItem.swift
//  google-maps-ios-utils-swift
//
//  Created by Eyal Darshan on 24/05/2016.
//  Copyright © 2016 eyaldar. All rights reserved.
//

import Foundation

protocol GQTPointQuadTreeItem: class {
    var point: GQTPoint { get }
}

func == (lhs: GQTPointQuadTreeItem,rhs: GQTPointQuadTreeItem) -> Bool {
    return lhs == rhs
}