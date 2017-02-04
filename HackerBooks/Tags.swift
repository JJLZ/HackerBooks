//
//  Tags.swift
//  HackerBooks
//
//  Created by JJLZ on 2/2/17.
//  Copyright © 2017 ESoft. All rights reserved.
//

import Foundation

class Tag: Hashable {
    
    let name: String;
    
    init(name: String) {
        
        self.name = name
    }
    
    //-- Hashable --
    private var scalarArray: [UInt32] = []
    
    // required var for the Hashable protocol
    var hashValue: Int {

        return self.scalarArray.reduce(5381) {
            ($0 << 5) &+ $0 &+ Int($1)
        }
    }
}

// MARK: Protocols

//-- Hashable --
func == (lhs: Tag, rhs: Tag) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

extension Tag: CustomStringConvertible {
    
    public var description: String {
        
        get {
            return "<\(type(of:self)): \(name)>"
        }
    }
}
