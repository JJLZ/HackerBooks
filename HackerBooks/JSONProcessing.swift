//
//  JSONProcessing.swift
//  HackerBooks
//
//  Created by JJLZ on 1/28/17.
//  Copyright © 2017 ESoft. All rights reserved.
//

import Foundation
import UIKit

// MARK: Aliases

typealias JSONObject        = AnyObject
typealias JSONDictionary    = [String : JSONObject]
typealias JSONArray         = [JSONDictionary]

// MARK: - Loading

//func loadJsonFileFrom(localUrl: URL) throws -> JSONArray {
//    
//    if let data = try? Data(contentsOf: localUrl),
//        let maybeArray = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? JSONArray,
//        let array = maybeArray {
//        
//        return array
//    } else {
//        throw HackerBooksErrors.jsonParsingError
//    }
//}

func loadJsonFileFrom(localUrl: URL) throws -> JSONArray {
    
    if let data = try? Data(contentsOf: localUrl),
        let maybeArray = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? JSONArray,
        let array = maybeArray {
        
        //--newcode Array o Diccionario --
        // http://stackoverflow.com/questions/28325268/convert-array-to-json-string-in-swift
        // http://stackoverflow.com/questions/30480672/how-to-convert-a-json-string-to-a-dictionary
        //--
        
        return array
    } else {
        throw HackerBooksErrors.jsonParsingError
    }
}


// MARK: Decoding

func decode(book json: JSONDictionary) throws -> Book {
    
    guard let pdfUrlString = json["pdf_url"] as? String, let pdfUrl = URL(string: pdfUrlString) else {
        
        throw HackerBooksErrors.wrongURLFormatForJSONResource
    }
    
    guard let imageUrlString = json["image_url"] as? String, let imageUrl = URL(string: imageUrlString) else {
        
        throw HackerBooksErrors.wrongURLFormatForJSONResource
    }
    
    //-- Extraer autores --
    let authors: [String]
    if let authorsString = json["authors"] {
        
        authors = createAuthorsArrayFrom(authors: authorsString as! String)
    } else {
        
        throw HackerBooksErrors.wrongURLFormatForJSONResource
    }
    //--
    
    //-- Extraer tags --
    let tags: [Tag]
    if let stringTags = json["tags"] {
        
        tags = createTagArrayFrom(tagString: stringTags as! String)
    } else {
        
        throw HackerBooksErrors.wrongURLFormatForJSONResource
    }
    //--
    
    let title = json["title"] as! String
    
    // Creamos el book
    return Book(title: title, authors: authors, tags: tags, imageUrl: imageUrl, pdfUrl: pdfUrl)
}

func createAuthorsArrayFrom(authors: String) -> [String] {
    
    let firstArray = authors.components(separatedBy: ",")
    var finalArray: [String] = []
    
    // Eliminar espacios en blanco a los extremos de cada author
    for author in firstArray {
        finalArray.append(author.trimmingCharacters(in: .whitespaces))
    }
    
    return finalArray
}

func createTagArrayFrom(tagString: String) -> [Tag] {
    
    let firstArray = tagString.components(separatedBy: ",")
    var tagArray: [Tag] = []
    
    for tag in firstArray {
        
        // Eliminar espacios en blanco y crear Tag elements
        tagArray.append(Tag(name: tag.trimmingCharacters(in: .whitespaces)))
    }
    
    return tagArray
}

//"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

//"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"

//"But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. To take a trivial example, which of us ever undertakes laborious physical exercise, except to obtain some advantage from it? But who has any right to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences, or one who avoids a pain that produces no resultant pleasure?"e
