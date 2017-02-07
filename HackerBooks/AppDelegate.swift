//
//  AppDelegate.swift
//  HackerBooks
//
//  Created by JJLZ on 1/28/17.
//  Copyright © 2017 ESoft. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: Constant
    static let notificationName = Notification.Name(rawValue: "JSONLoadComplete")
    static let LoadKey = "LoadKey"

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let defaults = UserDefaults.standard
        
        // Ruta completa para books.json dentro de nuestra carpeta Documents
        var jsonFileUrl = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first!
        jsonFileUrl.appendPathComponent("books.json")
        
        var bookArray = [Book]()
        
        // Verificamos UserDefaults para ver si el archivo ya ha sido descargado
        let isLocal = defaults.bool(forKey: "jsonDocumentIsAlreadyDownloaded")
        
        if isLocal { // Si el archivo json ya ha sido descargado
            
            // Hacemos el parsing del json y cargamos nuestro modelo
            bookArray = loadDataFromJsonFile(localUrl: jsonFileUrl)
            
        } else { // El json no esta en local
            
            // Lo descargamos desde https://t.co/K9ziV0z3SJ y lo guradamos en en la carpeta Documents
            if let url = URL(string: "https://t.co/K9ziV0z3SJ") {
                
                Downloader.load(url: url, to: jsonFileUrl, completion: {
                    
                    // Actualizamos bandera en UserDefaults para no volverlo a descargar
                    defaults.set(true, forKey: "jsonDocumentIsAlreadyDownloaded")
                    defaults.synchronize()
                    
                    // Hacemos el parsing del json y cargamos nuestro modelo
                    bookArray = self.loadDataFromJsonFile(localUrl: jsonFileUrl)
                    
                    //-- Crear library y enviarla como notificación --
                    let library = Library(books: bookArray)
                    self.sendLibraryFull(library: library)
                    //--
                })
            }
        }
        
        // Crear nuestro modelo Library
        let library = Library(books: bookArray)
        
        let libraryVC = LibraryViewController(model: library)
        let leftNavC = UINavigationController(rootViewController: libraryVC)
        
        //-- ipad --
        let splitVC = UISplitViewController()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            // creamos un BookViewController (por defecto mostrando el primer libro en el library)
            let bookVC = BookViewController(model: library.books[0])
            // lo cargamos en un nuevo UINavigationController
            let rigthNavC = UINavigationController(rootViewController: bookVC)
            
            // asignamos delegado
            libraryVC.delegate = bookVC
            
            // Creamos el splitVC
            splitVC.viewControllers = [leftNavC, rigthNavC]
        }
        //--
        
        window = UIWindow(frame: UIScreen.main.bounds)
        if UIDevice.current.userInterfaceIdiom == .pad {
            window?.rootViewController = splitVC
        } else {
            window?.rootViewController = leftNavC
        }
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func loadDataFromJsonFile(localUrl: URL) -> [Book] {
        
        do {
            // Pasamos la url a la función encargada de iniciar el parsing
            // Array de diccionarios de JSON
            let json = try loadJsonFileFrom(localUrl: localUrl)
            
            var books = [Book]()
            for dict in json {
                
                do {
                    let book = try decode(book: dict)
                    books.append(book)
                } catch {
                    print("Error al procesar \(dict)")
                }
            }
            
            return books;
            
        } catch {
            
            fatalError("Error while loading JSON file")
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

// MARK: Notifications

extension AppDelegate {
    
    // Prepar notificación para enviar library full cuando este lista
    func sendLibraryFull(library: Library) {
        
        // crear una instancia del notification center
        let nc = NotificationCenter.default
        
        // crear un objeto notificacion
        let notification = Notification(name: AppDelegate.notificationName, object: self, userInfo: [AppDelegate.LoadKey: library])
        
        // Lo mandas
        nc.post(notification)
    }
}

//"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

//"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"

//"But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. To take a trivial example, which of us ever undertakes laborious physical exercise, except to obtain some advantage from it? But who has any right to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences, or one who avoids a pain that produces no resultant pleasure?"
