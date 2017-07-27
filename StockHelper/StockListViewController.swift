//
//  StockListViewController.swift
//  StockHelper
//
//  Created by Victor Hong on 09/05/2017.
//  Copyright © 2017 Victor Hong. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI

class StockListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loginButton: UIBarButtonItem!
    @IBOutlet weak var signoutButton: UIBarButtonItem!
    
    var userList: [String] = []
    var watchList: [String: AlphaStock] = [String: AlphaStock]()
    var ref: FIRDatabaseReference!
    fileprivate var _refHandle: FIRDatabaseHandle!
    fileprivate var _authHandle: FIRAuthStateDidChangeListenerHandle!
    var user: FIRUser?
    var displayName = "Anonymous"

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        collectionView.register(UINib(nibName: "StockListCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "stockListCell")
        
        configureAuth()
        
    }
    
    override func viewDidLayoutSubviews() {
        
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { fatalError("Expected the collection view to have a UICollectionViewFlowLayout") }
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize.width = 100
        layout.itemSize.height = 100
        
    }
    
    @IBAction func loginAction(_ sender: Any) {
    }
    
    @IBAction func signoutAction(_ sender: Any) {
        
        userList.append("NFLX")
        userList.append("NFLX")
        
        let set = Set(userList)
        
        userList = Array(set)
        
        ref.child("user").child((user?.uid)!).child("list").setValue(userList)
        
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
                
                AlphaStockManager.fetchRealTimeStock(term: list, completion: { (stock) in
                    self.watchList[list] = stock
                    self.collectionView.reloadData()
                })
                
            }
            
        }
        
        _refHandle = ref.child("user").child((user?.uid)!).observe(.childChanged) { (snapshot: FIRDataSnapshot) in
            
            let listSnapshot: FIRDataSnapshot! = snapshot
            let list = listSnapshot.value as! [String]
            self.userList = list
            
            for list in self.userList {
                
                AlphaStockManager.fetchRealTimeStock(term: list, completion: { (stock) in
                    self.watchList[list] = stock
                    self.collectionView.reloadData()
                })
                
            }
            
        }

    }
    
    // MARK: Sign In and Out
    
    func signedInStatus(isSignedIn: Bool) {
        loginButton.isEnabled = !isSignedIn
        signoutButton.isEnabled = isSignedIn
        //        messagesTable.isHidden = !isSignedIn
        //        messageTextField.isHidden = !isSignedIn
        //        sendButton.isHidden = !isSignedIn
        //        imageMessage.isHidden = !isSignedIn
        
        if (isSignedIn) {
            //tableView.isHidden = true
            // remove background blur (will use when showing image messages)
//            tableView.rowHeight = UITableViewAutomaticDimension
//            tableView.estimatedRowHeight = 70
            
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showDetailVC" {
            if let vc = segue.destination as? DetailViewController {
                let indexPath = sender as! IndexPath
                vc.stockSymbol = userList[indexPath.row]
            }
        }
        
    }
 

}

extension StockListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stockListCell", for: indexPath) as? StockListCollectionViewCell
        
        cell?.stockListView.layer.borderColor = UIColor.black.cgColor
        cell?.stockListView.layer.borderWidth = 1
        
        if indexPath.row % 2 == 0 {
            cell?.stockListView.backgroundColor = .red
        } else {
            cell?.stockListView.backgroundColor = .green
        }
        
        if let stock = watchList[userList[indexPath.row]] {
            cell?.setData(stock)
        } else {
            cell?.companyLabel.text = "Data still loading"
        }

        //cell?.companyLabel.text = "\(indexPath.row)"
        
        return cell!
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "showDetailVC", sender: indexPath)
        
    }
    
}
