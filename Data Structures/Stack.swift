//
//  Stack.swift
//  google-maps-ios-utils-swift
//
//  Created by Eyal Darshan on 25/05/2016.
//  Copyright © 2016 eyaldar. All rights reserved.
//

import Foundation

struct Stack<Element> {
    private var max: Int
    private var items = [Element]()
    
    var count: Int {
        return items.count
    }
    
    init(max: Int = 64) {
        self.max = max
    }
    
    mutating func push(item: Element) {
        if count + 1 >= max {
            pop()
        }
        
        items.append(item)
    }
    mutating func pop() -> Element? {
        if count > 0 {
            return items.removeLast()
        }
        
        return nil
    }
}