//
//  Multidictionary.swift
//  HackerBooks
//
//  Created by JJLZ on 1/31/17.
//  Copyright © 2017 ESoft. All rights reserved.
//

import Foundation

// Ejemplo de uso
//var map = MutiDictionary<String , Int>()
//
//var pares = Set<Int>()
//pares.insert(2)
//pares.insert(4)
//
//map["Pares"] = pares    // setter
//map["Pares"]            // getter

public
struct MutiDictionary <Key: Hashable, Value: Hashable> {
    
    // MARK: - Types
    public
    typealias Bucket = Set<Value>
    
    // MARK: Properties
    private
    var _dict : [Key : Bucket]
    
    // MARK: Lifecycle
    public
    init() {
        _dict = Dictionary()
    }
    
    // MARK: Accessors
    public
    var isEmpy: Bool {
        return _dict.isEmpty
    }
    
    public
    var countBuckets: Int {
        return _dict.count
    }
    
    public
    var count : Int {
        
        var total = 0
        for bucket in _dict.values {
            total += bucket.count
        }
        return total
    }
    
    public
    var countUnique: Int {
        var total = Bucket()
        
        for bucket in _dict.values {
            total = total.union(bucket)
        }
        
        return total.count
    }
    
    // MARK: Setters (Mutators)
    public
    subscript(key: Key) -> Bucket? {
        
        get {
            return _dict[key]
        }
        
        set(maybeNewBucket) {
            guard let newBucket = maybeNewBucket else {
                // añadir nada es no añadir
                return
            }
            
            guard let previous = _dict[key] else {
                // Si no había nada bajo dicha clave
                // la añadimos con un bucket vacio
                _dict[key] = Bucket()
                return
            }
            
            // Creamos una unión de lo viejo y lo nuevo
            _dict[key] = previous.union(newBucket)
        }
    }
    
    // Toda función que cambie el estado (self) de la estructura
    // tiene que venir precedida por la palabreja mutatin
    public
    mutating func insert(value: Value, forKey key: Key) {
        
        if var previous = _dict[key] {
            previous.insert(value)
            _dict[key] = previous
        } else {
            _dict[key] = [value]
        }
    }
    
    // Cosas que faltan (ver slack para la versión completa)
    // eliminar valures
    // poder iterear por el multiDict como lo hase por un diccionario
}

//"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

//"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"

//"But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. To take a trivial example, which of us ever undertakes laborious physical exercise, except to obtain some advantage from it? But who has any right to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences, or one who avoids a pain that produces no resultant pleasure?"
