//
//  PDFViewerViewController.swift
//  HackerBooks
//
//  Created by JJLZ on 2/5/17.
//  Copyright © 2017 ESoft. All rights reserved.
//

import UIKit

class PDFViewerViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var vWeb: UIWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // MARK: Properties
    var model: Book
    
    // MARK: Intialization
    init(model: Book){
        
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: ViewController lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        subscribe()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // mostrar título del libro
        self.title = model.title

        // Comenzar la descargad el PDF
        downloadPDF(pdfURL: model.pdfUrl)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        unsubscribe()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Methods
    func downloadPDF(pdfURL: URL) {
        
        let defaultPDF: Data = try! Data(contentsOf: Bundle.main.url(forResource: "libro", withExtension: "pdf")!)
        let asyncData = AsyncData(url: pdfURL, defaultData: defaultPDF)
        
        spinner.isHidden = false
        spinner.startAnimating()
        
        asyncData.delegate = self
        vWeb.load(asyncData.data, mimeType: "application/pdf", textEncodingName:"", baseURL: pdfURL.deletingLastPathComponent())
    }
}

// MARK: Delegates

extension PDFViewerViewController: AsyncDataDelegate {
    
    func asyncData(_ sender: AsyncData, shouldStartLoadingFrom url: URL) -> Bool {
        
        return true
    }
    
    func asyncData(_ sender: AsyncData, willStartLoadingFrom url: URL) {
        
    }
    
    func asyncData(_ sender: AsyncData, didEndLoadingFrom url: URL) {
        
        DispatchQueue.main.async {
            
            self.spinner.isHidden = true
            self.spinner.stopAnimating()            
            
            self.vWeb.load(sender.data, mimeType: "application/pdf", textEncodingName:"", baseURL: url)
        }
    }
}

// MARK: Notifications

extension PDFViewerViewController {
    
    func subscribe() {

        let nc = NotificationCenter.default
        nc.addObserver(forName: LibraryViewController.notificationName, object: nil, queue: OperationQueue.main) {(note: Notification) in
        
            let userInfo = note.userInfo
            let book = userInfo?[LibraryViewController.bookKey]
            
            self.model = book as! Book
            self.title = self.model.title
            self.downloadPDF(pdfURL: self.model.pdfUrl)
        }
    }
    
    func unsubscribe() {
        
        let nc = NotificationCenter.default
        nc.removeObserver(self)
    }
}

//"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

//"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"

//"But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. To take a trivial example, which of us ever undertakes laborious physical exercise, except to obtain some advantage from it? But who has any right to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences, or one who avoids a pain that produces no resultant pleasure?"
