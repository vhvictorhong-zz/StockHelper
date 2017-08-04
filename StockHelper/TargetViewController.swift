//
//  TargetViewController.swift
//  StockHelper
//
//  Created by Victor Hong on 28/07/2017.
//  Copyright © 2017 Victor Hong. All rights reserved.
//

import UIKit
import Firebase

class TargetViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let singleton = Singleton.sharedInstance
    
    fileprivate var _refHandle: FIRDatabaseHandle!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        collectionView.register(UINib(nibName: "TargetCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "targetCell")
        
        configureDatabase()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { fatalError("Expected the collection view to have a UICollectionViewFlowLayout") }
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize.width = self.view.bounds.size.width/4
        layout.itemSize.height = self.view.bounds.size.width/4
        
    }
    
    @IBAction func refreshAction(_ sender: Any) {
        
        collectionView.reloadData()
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showPriceChangeVC" {
            if let vc = segue.destination as? PriceChangeViewController {
                let indexPath = sender as! IndexPath

                guard var price = singleton.targetList[singleton.arrayTarget[indexPath.row]] else {
                    return
                }
                
                price = Double(price).roundTo(places: 2)
                vc.price = price
                vc.stockSymbol = singleton.arrayTarget[indexPath.row]
            }
        }
        
    }
    
    func configureDatabase() {
        
        _refHandle = singleton.ref?.child("user").child((singleton.user?.uid)!).child("targetList").observe(.childChanged) { (snapshot: FIRDataSnapshot) in
            
            self.collectionView.reloadData()
            
        }
    }
    
}

extension TargetViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return singleton.targetList.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "targetCell", for: indexPath) as? TargetCollectionViewCell
        
        cell?.setData(alphaStock: singleton.arrayTarget[indexPath.row], targetList: singleton.targetList)
        
//        if let alphaStock = singleton.watchList[singleton.arrayTarget[indexPath.row]] {
//            cell?.setData(alphaStock: alphaStock, targetList: singleton.targetList)
//        }
        
        return cell!
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "showPriceChangeVC", sender: indexPath)
        
    }
    
}
