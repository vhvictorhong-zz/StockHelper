//
//  DetailViewController.swift
//  StockHelper
//
//  Created by Victor Hong on 29/03/2017.
//  Copyright © 2017 Victor Hong. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var stockSymbol = String()
    var stock: StockModel?
    
    let singleton = Singleton.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.title = stockSymbol
        let btn1 = UIButton(type: UIButtonType.contactAdd)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.addTarget(self, action: #selector(DetailViewController.addToList), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        
        navigationItem.setRightBarButton(item1, animated: true)
        
        collectionView.register(UINib(nibName: "StockDataCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "stockDataCell")
        AlphaStockManager.fetchStockForSymbol(symbol: stockSymbol) { (stock) in
            
            self.stock = stock
            self.collectionView.reloadData()
        }
        
    }

    override func viewDidLayoutSubviews() {
        
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { fatalError("Expected the collection view to have a UICollectionViewFlowLayout") }
        
        layout.itemSize.width = self.view.bounds.size.width / 2.1
        //layout.itemSize.height = self.view.bounds.size.width / 1.5
        
    }
    
    func addToList() {
        
        singleton.userList.append(stockSymbol)
        
        let set = Set(singleton.userList)
        singleton.userList = Array(set)
        
        if singleton.targetList[stockSymbol] == nil {
            
            singleton.ref?.child("user").child((singleton.user?.uid)!).child("targetList").updateChildValues([stockSymbol: 0.0])
            
        }
        
        singleton.ref?.child("user").child((singleton.user?.uid)!).child("list").child("array").setValue(singleton.userList)
        
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

// MARK: - CollectionViewDelegate, CollectionViewDataSource

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return stock != nil ? 18 : 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return section == 17 ? 1 : 2
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stockDataCell", for: indexPath) as! StockDataCollectionViewCell
        
        cell.setData((stock!.dataFields?[(indexPath.section * 2) + indexPath.row])!)
        
        return cell
        
    }
    
}
