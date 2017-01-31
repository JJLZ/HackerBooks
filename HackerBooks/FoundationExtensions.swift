//
//  FoundationExtensions.swift
//  StarWars
//
//  Created by JJLZ on 1/19/17.
//  Copyright © 2017 ESoft. All rights reserved.
//

import Foundation

extension Bundle {
    
    func url(forResource name: String) -> URL? {
        
        // Partir el nombre por el .
        let tokens = name.components(separatedBy: ".")
        
        // Si sale bien, crear la url
        return url(forResource: tokens[0], withExtension: tokens[1])
    }
}
