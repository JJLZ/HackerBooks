//
//  Library.swift
//  HackerBooks
//
//  Created by JJLZ on 1/28/17.
//  Copyright © 2017 ESoft. All rights reserved.
//

import Foundation
import UIKit

// MARK: typealias list
typealias TagName = String
typealias BooksArray = [Book]
typealias TagsArray = [Tag]

class Library {
    
    // MARK: Stored Properties
    var books: [Book]
    var tags: [Tag]
    var booksCount: Int {
        
        get {
            let count: Int = self.books.count
            return count
        }
    }
    
    // MARK: Initialization
    init(books: BooksArray, tags: TagsArray) {
        
        self.books = books;
        self.tags = tags;
    }
    
//    // Cantidad de libros que hay un una temática.
//    // Si el tag no existe, debe de devolver cero.
//    func bookCount(forTagName name: TagName) -> Int {
//        
//    }
//    
//    // Array de los libros (instancias de Book) que hay en una temática.
//    // Un libro puede estar en una o más temáticas.
//    // Si no hay libros para una temática, ha de devolver nil.
//    func books(forTagName name: TagName) -> [Book]? {
//        
//        
//    }
//    
//    // Un AGTBook para el libro que está en loa posición 'index'
//    // de aquellos bajo un cierto tag.
//    // Mira a ver si puedes usar el método anterior para hacer parte
//    // de tu trabajo.
//    // Si el indice no existe o el tag no existe, ha de devolver nil.
//    func book(forTagName name: TagName, at: Int) -> Book? {
//        
//    }
}
