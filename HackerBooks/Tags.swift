//
//  Tags.swift
//  HackerBooks
//
//  Created by JJLZ on 2/2/17.
//  Copyright © 2017 ESoft. All rights reserved.
//

import Foundation

class Tag: Hashable, Equatable {
    
    let name: String;
    
    init(name: String) {
        
        self.name = name
    }
    
    //-- Hashable --
    var hashValue : Int {
        get {
            return self.name.hashValue
        }
    }
    //--
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
