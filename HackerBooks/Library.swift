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
    init(books: BooksArray) {
        
        self.books = books;
        
        // Obtener el array de tags de todos los libros
        var allTags:[Tag] = []
        for book in self.books {
            
            allTags.append(contentsOf: book.tags)
        }
        
        // Obtener array de Tag ordenado y sin elementos duplicados
        // para usuarlo como key en el multidictionary

        // eliminando duplicados
        let uniqueArray:[Tag] = Array(Set(allTags))
        
        // ordenando los tags en orden alfabetico
        var sortedArray:[Tag] = uniqueArray.sorted(by: {$0.name < $1.name})
        
        // agregando el tag "Favorito" como primer elemento del array ordenado
        let tagFavorite = Tag(name: "Favorite")
        sortedArray.insert(tagFavorite, at: 0)
        
        // ya tenemos lo que buscamos
        self.tags = sortedArray
        print("\(self.tags)")
        
        // Cargar el multidictionary
        var almacen = MultiDictionary<TagName, Book>()
        
        almacen.insert(value: self.books[0], forKey: "Hola")
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

//"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

//"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"

//"But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. To take a trivial example, which of us ever undertakes laborious physical exercise, except to obtain some advantage from it? But who has any right to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences, or one who avoids a pain that produces no resultant pleasure?"
