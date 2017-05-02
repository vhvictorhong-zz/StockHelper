//
//  WatchListViewController.swift
//  StockHelper
//
//  Created by Victor Hong on 04/04/2017.
//  Copyright © 2017 Victor Hong. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI

class WatchListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var arrayWL = ["IBM", "AMD", "AKER"]
    var watchList: [String: Stock]?
    var ref: FIRDatabaseReference!
    fileprivate var _refHandle: FIRDatabaseHandle!
    fileprivate var _authHandle: FIRAuthStateDidChangeListenerHandle!
    var user: FIRUser?
    var displayName = "Anonymous"

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureAuth()
        
        watchList = [String: Stock]()
        
        tableView.register(UINib(nibName: "StockWLDataTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "stockWLDataCell")
        for list in arrayWL {
            StockManager.fetchStockForSymbol(symbol: list, completion: { (stock) in
                self.watchList![list] = stock
                self.tableView.reloadData()
            })
        }
        
        
    }
    
    // MARK: Config
    
    func configureAuth() {
        
        let provider: [FUIAuthProvider] = [FUIGoogleAuth()]
        FUIAuth.defaultAuthUI()?.providers = provider
        
        _authHandle = FIRAuth.auth()?.addStateDidChangeListener({ (auth: FIRAuth, user: FIRUser?) in
            
            
            //check if there is a current user
            if let activeUser = user {
                //check if the current app user is the current FIRUser
                if self.user != activeUser {
                    self.user = activeUser
                    self.signedInStatus(isSignedIn: true)
                    let name = user!.email!.components(separatedBy: "@")[0]
                    self.displayName = name
                }
            } else {
                //user must sign in
                self.signedInStatus(isSignedIn: false)
                self.loginSession()
            }
        })
        
    }
    
    func configureDatabase() {
        
        ref = FIRDatabase.database().reference()
        _refHandle = ref.child("messages").observe(.childAdded) { (snapshot: FIRDataSnapshot) in
            
//            self.messages.append(snapshot)
//            self.messagesTable.insertRows(at: [IndexPath(row: self.messages.count - 1, section: 0)], with: .automatic)
//            self.scrollToBottomMessage()
            
        }
        
    }
    
    // MARK: Sign In and Out
    
    func signedInStatus(isSignedIn: Bool) {
//        signInButton.isHidden = isSignedIn
//        signOutButton.isHidden = !isSignedIn
//        messagesTable.isHidden = !isSignedIn
//        messageTextField.isHidden = !isSignedIn
//        sendButton.isHidden = !isSignedIn
//        imageMessage.isHidden = !isSignedIn
        
        if (isSignedIn) {
            
            // remove background blur (will use when showing image messages)
//            messagesTable.rowHeight = UITableViewAutomaticDimension
//            messagesTable.estimatedRowHeight = 122.0
//            backgroundBlur.effect = nil
//            messageTextField.delegate = self
            
//            configureDatabase()
//            configureStorage()
//            configureRemoteConfig()
//            fetchConfig()
            
        }
    }
    
    func loginSession() {
        let authViewController = FUIAuth.defaultAuthUI()!.authViewController()
        self.present(authViewController, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WatchListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayWL.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockWLDataCell", for: indexPath) as! StockWLDataTableViewCell
        
        if let stock = watchList?[arrayWL[indexPath.row]] {
            cell.setData(stock)
        } else {
            cell.symbolLabel.text = "Data still loading"
        }
        
        return cell
        
    }
    
}
