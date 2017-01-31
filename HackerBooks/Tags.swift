//
//  Tags.swift
//  HackerBooks
//
//  Created by JJLZ on 2/2/17.
//  Copyright © 2017 ESoft. All rights reserved.
//

import Foundation

class Tag {
    
    let name: String;
    
    init(name: String) {
        
        self.name = name
    }
}

extension Tag: CustomStringConvertible {
    
    public var description: String {
        
        get {
            return "<\(type(of:self)): \(name)>"
        }
    }
}
