//
//  LibraryViewController.swift
//  HackerBooks
//
//  Created by JJLZ on 1/31/17.
//  Copyright © 2017 ESoft. All rights reserved.
//

import UIKit

let cellIdetifier: String = "CustomCell"

class LibraryViewController: UITableViewController {
    
    // MARK: Constants
    static let notificationName = Notification.Name(rawValue: "BookDidChange")
    static let bookKey = "BookKey"
    
    // MARK: Properties
    var model: Library
    weak var delegate: LibraryViewControllerDelegate? = nil
    
    // MARK: Initialization
    init(model: Library) {
        
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        
        // limpiar la casa
        unsubscribeOfNotifications()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: ViewController lifecylce
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //-- Si library llego vacío solitar recibir cuando este completa --
        if model.books.isEmpty {
            
            self.subscribeToNotificationLibraryFull()
        }
        //--
        
        self.title = "Hacker Books"
        
        // detectar cambios para actualizar la sección "Favorite"
        subscribeToNotifications()
        
        // registrar el custom cell
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdetifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return model.tags.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let tag: Tag = model.tags[section]
        return model.bookCount(forTagName: tag.name)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let tag: Tag = model.tags[section]
        let name = tag.name.capitalized
        
        return name
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let defaultHeight: CGFloat = 35.0
        var headerHeight: CGFloat
        
        switch section {
            
        case 0: // sección "Favorite"
            
            // "Esconder" el header cuando no tengamos favoritos
            if model.bookCount(forTagName: "favorite") == 0 {
                
                headerHeight = 0.0
            } else {
                
                headerHeight = defaultHeight
            }
            
        default:
            headerHeight = defaultHeight
        }
        
        return headerHeight
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 97.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdetifier, for: indexPath) as! CustomTableViewCell
        
        // Obtener el book correspondiente al cell actual
        let tag: Tag = model.tags[indexPath.section]
        let book: Book = model.book(forTagName: tag.name, at: indexPath.row)!
        
        // Fill with book info
        cell.downloadCoverImage(imageURL: book.imageUrl)    // download image
        cell.lblTitle?.text = book.title
        cell.lblAuthors?.text = book.authors.joined(separator: ", ")
        cell.lblTags?.text = book.tagsInString
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Obtener el libro correspondiente al sell seleccionado
        let tag: Tag = model.tags[indexPath.section]
        let book: Book = model.book(forTagName: tag.name, at: indexPath.row)!
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            
            // Presentar el book view controller con el book seleccionado
            let bookVC = BookViewController(model: book)
            self.navigationController?.pushViewController(bookVC, animated: true)
        } else { // para ipad
            
            // avisamos al delegado
            delegate?.libraryViewController(self, didSelectBook: book)
            
            // mandamos una notificación
            notifyBookHasChanged(newBook: book)
        }
    }
}

// MARK: Notifications

extension LibraryViewController {
    
    func subscribeToNotifications() {
        
        let nc = NotificationCenter.default
        
        nc.addObserver(forName: BookViewController.notificationName, object: nil, queue: OperationQueue.main) { (note: Notification) in
            
            // extraigo el libro de la notificacion
            let userInfo = note.userInfo
            let book: Book = userInfo?[BookViewController.BookKey] as! Book
            
            //-- Guardar en Userdefaults el nuevo estado para "favorite" --
            // Nota: tomamos el hashValue del title como identificador único
            let defaults = UserDefaults.standard
            defaults.set(book.isFavorite, forKey: String(book.title.hashValue))
            defaults.synchronize()
            //--
            
            //-- Actualizar los tags del Book y el almacen para el tag "favorite" --
            let favoriteTag: Tag = Tag(name: "favorite")
            
            if book.isFavorite {
                
                // agregar tag "favorite" al libro
                book.tags.append(favoriteTag)
                
                // agregar libro al los favoritos en el almacen
                self.model.insert(book: book, forTag: favoriteTag)
            } else {
                
                // eliminar tag "favorite" al libro
                book.tags = book.tags.filter{$0 != favoriteTag}
                
                // remover libro del Favoritos en el almacen
                self.model.remove(book: book, forTag: favoriteTag)
            }
            
//            self.tableView.beginUpdates()
//            self.tableView.reloadSections([0], with: .fade)
//            self.tableView.endUpdates()
            
            self.tableView.reloadData()
        }
    }
    
    func unsubscribeOfNotifications() {
        
        let nc = NotificationCenter.default
        nc.removeObserver(self)
    }
}

extension LibraryViewController {
    
    func subscribeToNotificationLibraryFull() {
        
        let nc = NotificationCenter.default
        
        nc.addObserver(forName: AppDelegate.notificationName, object: nil, queue: OperationQueue.main) { (note: Notification) in
            
            let userInfo = note.userInfo
            let library: Library = userInfo?[AppDelegate.LoadKey] as! Library
            
            // Cargar la libreria completa y cargar tabla
            self.model = library
            self.tableView.reloadData()
            
            // Stop listening notification
            nc.removeObserver(self, name: AppDelegate.notificationName, object: nil);
        }
    }
}

extension LibraryViewController {
    
    func notifyBookHasChanged(newBook book: Book) {
        
        let nc = NotificationCenter.default
        let notification = Notification(name: LibraryViewController.notificationName, object: self, userInfo: [LibraryViewController.bookKey : book])
        nc.post(notification)
    }
}

// MARK: Protocols

protocol LibraryViewControllerDelegate: class {
    
    func libraryViewController(_ lVC: LibraryViewController, didSelectBook book: Book)
}

//"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

//"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"

//"But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. To take a trivial example, which of us ever undertakes laborious physical exercise, except to obtain some advantage from it? But who has any right to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences, or one who avoids a pain that produces no resultant pleasure?"
