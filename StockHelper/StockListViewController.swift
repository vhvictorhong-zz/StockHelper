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
    
    fileprivate var _refHandle: FIRDatabaseHandle!
    fileprivate var _authHandle: FIRAuthStateDidChangeListenerHandle!
    var displayName = "Anonymous"
    
    let singleton = Singleton.sharedInstance
    
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
        layout.itemSize.width = self.view.bounds.size.width/4
        layout.itemSize.height = self.view.bounds.size.width/4
        
    }
    
    @IBAction func loginAction(_ sender: Any) {
    }
    
    @IBAction func signoutAction(_ sender: Any) {
        
//        userList.append("NFLX")
//        userList.append("NFLX")
//        
//        let set = Set(userList)
//        
//        userList = Array(set)
//        
//        singleton.ref?.child("user").child((singleton.user?.uid)!).child("list").child("array").setValue(singleton.userList)
        
        let target = ["APPL": 54.2]
        
        //singleton.ref?.child("user").child((singleton.user?.uid)!).child("targetList").setValue(target)
        //singleton.ref?.child("user").child((singleton.user?.uid)!).child("targetList").updateChildValues(target)
        
    }

    
    // MARK: Config
    
    func configureAuth() {
        
        let provider: [FUIAuthProvider] = [FUIGoogleAuth()]
        FUIAuth.defaultAuthUI()?.providers = provider
        
        _authHandle = FIRAuth.auth()?.addStateDidChangeListener({ (auth: FIRAuth, user: FIRUser?) in
            
            
            //check if there is a current user
            if let activeUser = user {
                //check if the current app user is the current FIRUser
                if self.singleton.user != activeUser {
                    self.singleton.user = activeUser
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
        
        singleton.ref = FIRDatabase.database().reference()
        _refHandle = singleton.ref?.child("user").child((singleton.user?.uid)!).child("list").observe(.childAdded) { (snapshot: FIRDataSnapshot) in
            
            let listSnapshot: FIRDataSnapshot! = snapshot
            let list = listSnapshot.value as! [String]
            self.singleton.userList = list
            
            for list in self.singleton.userList {
                
                AlphaStockManager.fetchRealTimeStock(term: list, completion: { (stock) in
                    self.singleton.watchList[list] = stock
//                    var priceChangeArray: [Double] = []
//                    for priceChange in self.watchList {
//                        priceChangeArray.append(priceChange.value.priceChange!)
//                    }
                    
                    
//                    self.watchList[list]?.priceChange
//                    a = a.sort { $0 > $1 }
//                    print(a)
                    
                    self.collectionView.reloadData()
                })
                
            }
            
        }
        
        _refHandle = singleton.ref?.child("user").child((singleton.user?.uid)!).child("list").observe(.childChanged) { (snapshot: FIRDataSnapshot) in
            
            let listSnapshot: FIRDataSnapshot! = snapshot
            let list = listSnapshot.value as! [String]
            self.singleton.userList = list
            
            for list in self.singleton.userList {
                
                AlphaStockManager.fetchRealTimeStock(term: list, completion: { (stock) in
                    self.singleton.watchList[list] = stock
                    self.collectionView.reloadData()
                })
                
            }
            
        }
        
        _refHandle = singleton.ref?.child("user").child((singleton.user?.uid)!).child("targetList").observe(.childAdded) { (snapshot: FIRDataSnapshot) in
            
            let listSnapshot: FIRDataSnapshot! = snapshot
            let list = listSnapshot.key 
            let valueList = listSnapshot.value as! Double
            
            self.singleton.targetList[list] = valueList
            self.singleton.arrayTarget.append(list)
            
        }
        
        _refHandle = singleton.ref?.child("user").child((singleton.user?.uid)!).child("targetList").observe(.childChanged) { (snapshot: FIRDataSnapshot) in
            
            let listSnapshot: FIRDataSnapshot! = snapshot
            let list = listSnapshot.key
            let valueList = listSnapshot.value as! Double
            
            self.singleton.targetList[list] = valueList
            self.singleton.arrayTarget.append(list)
            

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
                vc.stockSymbol = singleton.userList[indexPath.row]
            }
        }
        
    }
 

}

extension StockListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return singleton.userList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stockListCell", for: indexPath) as? StockListCollectionViewCell
        
        cell?.stockListView.layer.borderColor = UIColor.black.cgColor
        cell?.stockListView.layer.borderWidth = 1
        
        if let stock = singleton.watchList[singleton.userList[indexPath.row]] {
            cell?.setData(stock)
        } else {
            cell?.companyLabel.text = "Data still loading"
        }
        
        return cell!
        
    }
    

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "showDetailVC", sender: indexPath)
        
    }
    
}
