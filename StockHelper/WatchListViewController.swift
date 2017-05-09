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
    @IBOutlet weak var signInButton: UIBarButtonItem!
    @IBOutlet weak var signOutButton: UIBarButtonItem!

    
    var userList: [String] = []
    var watchList: [String: Stock] = [String: Stock]()
    var ref: FIRDatabaseReference!
    fileprivate var _refHandle: FIRDatabaseHandle!
    fileprivate var _authHandle: FIRAuthStateDidChangeListenerHandle!
    var user: FIRUser?
    var displayName = "Anonymous"

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
        configureAuth()
        
        tableView.register(UINib(nibName: "StockWLDataTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "stockWLDataCell")
        
    }
    
    // MARK: Actions
    
    @IBAction func randomButton(_ sender: Any) {
        
        //ref.child("user").child((user?.uid)!).setValue(["list": arrayWL])

        //ref.child(displayName).setValue(["number": arrayWL])

    }
    
    @IBAction func LoginAction(_ sender: Any) {
        
        loginSession()
    }
    
    @IBAction func signOutAction(_ sender: Any) {
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch {
            print("unable to sign out: \(error)")
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
        _refHandle = ref.child("user").child((user?.uid)!).observe(.childAdded) { (snapshot: FIRDataSnapshot) in
            
            let listSnapshot: FIRDataSnapshot! = snapshot
            let list = listSnapshot.value as! [String]
            self.userList = list
            
            for list in self.userList {
                StockManager.fetchStockForSymbol(symbol: list, completion: { (stock) in
                    self.watchList[list] = stock
                    self.tableView.reloadData()
                })
            }
            
        }
        
    }
    
    // MARK: Sign In and Out
    
    func signedInStatus(isSignedIn: Bool) {
        signInButton.isEnabled = !isSignedIn
        signOutButton.isEnabled = isSignedIn
//        messagesTable.isHidden = !isSignedIn
//        messageTextField.isHidden = !isSignedIn
//        sendButton.isHidden = !isSignedIn
//        imageMessage.isHidden = !isSignedIn
        
        if (isSignedIn) {
            //tableView.isHidden = true
            // remove background blur (will use when showing image messages)
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 70
            
            configureDatabase()
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
        
        return userList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockWLDataCell", for: indexPath) as! StockWLDataTableViewCell
        
        if let stock = watchList[userList[indexPath.row]] {
            cell.setData(stock)
        } else {
            cell.symbolLabel.text = "Data still loading"
        }
        
        return cell
        
    }
        
}
