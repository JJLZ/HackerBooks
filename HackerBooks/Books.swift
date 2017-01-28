//
//  Books.swift
//  HackerBooks
//
//  Created by JJLZ on 1/28/17.
//  Copyright © 2017 ESoft. All rights reserved.
//

import Foundation
import UIKit

class Book {
    
    // MARK: Stored Properties
    let title: String
    let authors: [String]
    let tags: [String]
    let imageUrl: URL
    let pdfUrl: URL
    
    let isFavorite: Bool = false
    
    // MARK: Initialization
    
    init(title: String, authors: [String], tags: [String], imageUrl: URL, pdfUrl: URL) {
        
        self.title = title;
        self.authors = authors;
        self.tags = tags;
        self.imageUrl = imageUrl;
        self.pdfUrl = pdfUrl;
    }
}
