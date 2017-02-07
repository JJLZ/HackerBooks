//
//  Errors.swift
//  HackerBooks
//
//  Created by JJLZ on 1/28/17.
//  Copyright © 2017 ESoft. All rights reserved.
//

import Foundation

enum HackerBooksErrors: Error {
    
    case jsonParsingError
    case wrongURLFormatForJSONResource
    case resourcePointedByURLNotReachable
    case wrongJSONFormat
}
