//
//  BookViewController.swift
//  HackerBooks
//
//  Created by JJLZ on 2/4/17.
//  Copyright © 2017 ESoft. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var ivCover: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var btnFavorite: UIBarButtonItem!
    
    // MARK: Constant
    static let notificationName = Notification.Name(rawValue: "FavoriteTagDidChange")
    static let BookKey = "BookKey"
    
    // MARK: Properties
    var model: Book
    
    var isFavorite : Bool {
        
        didSet {
            
            // actualizar estado en nuestro book
            model.isFavorite = self.isFavorite
            
            // Cambiar imagen de acuerdo al estado
            if isFavorite {
                btnFavorite.image = UIImage(named: "Favorite")
            } else {
                btnFavorite.image = UIImage(named: "noFavorite")
            }
        }
    }
    
    // MARK: Intialization
    init(model: Book){
        
        self.model = model
        isFavorite = model.isFavorite
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Lifecycle

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Descargar cover de libro
        downloadCoverImage(imageURL: model.imageUrl)
        
        // set favorite state
        isFavorite = model.isFavorite
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Methods
    func downloadCoverImage(imageURL: URL) {
        
        let defaultImageAsData = try! Data(contentsOf: Bundle.main.url(forResource: "libro", withExtension: "png")!)
        let asyncData = AsyncData(url: imageURL, defaultData: defaultImageAsData)
        
        spinner.isHidden = false
        spinner.startAnimating()
        
        asyncData.delegate = self
        ivCover.image = UIImage(data: asyncData.data)
    }
        
    // MARK: IBActions
    @IBAction func readBook(_ sender: Any) {
        
    }
    
    @IBAction func isFavoriteChange(_ sender: UIBarButtonItem) {
        
        // cambiar estado de la propiedad "Favorite"
        self.isFavorite = !self.isFavorite
        
        // notificamos a los interesados y les pasamos el Book modificado
        notify(bookChanged: self.model)
    }
}

// MARK: Delegates

extension BookViewController: AsyncDataDelegate {
    
    func asyncData(_ sender: AsyncData, shouldStartLoadingFrom url: URL) -> Bool {
        // nos pregunta si puede hacer la descarga.
        // por supuesto!
        return true
    }
    
    func asyncData(_ sender: AsyncData, willStartLoadingFrom url: URL) {
        // Nos avisa que va a empezar
        
    }
    
    func asyncData(_ sender: AsyncData, didEndLoadingFrom url: URL) {
        
        // la actualizo, y encima con una animación (más en el avanzado)
        UIView.transition(with: ivCover,
                          duration: 0.7,
                          options: [.transitionCrossDissolve],
                          animations: {
                            self.ivCover.image = UIImage(data: sender.data)
        }, completion: nil)
        
        spinner.stopAnimating()
        spinner.isHidden = true
    }
}

// MARK: Notifications

extension BookViewController {

    // Notificar a los interedos cuando la propiedad isFavorite de un Book ha cambiado
    func notify(bookChanged book: Book) {
        
        // crear una instancia del notification center
        let nc = NotificationCenter.default
        
        // crear un objeto notificacion
        let notification = Notification(name: BookViewController.notificationName, object: self, userInfo: [BookViewController.BookKey: book])
        
        // Lo mandas
        nc.post(notification)
    }
}


//"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

//"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"

//"But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. To take a trivial example, which of us ever undertakes laborious physical exercise, except to obtain some advantage from it? But who has any right to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences, or one who avoids a pain that produces no resultant pleasure?"
