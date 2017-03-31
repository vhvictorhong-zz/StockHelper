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
    
    var stock: Stock?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.register(UINib(nibName: "StockDataCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "stockDataCell")
        StockManager.fetchStockForSymbol(symbol: "F") { (stock) in
            
            self.stock = stock
            self.collectionView.reloadData()
        }
        
    }

    override func viewDidLayoutSubviews() {
        
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { fatalError("Expected the collection view to have a UICollectionViewFlowLayout") }
        
        layout.itemSize.width = self.view.bounds.size.width / 2.1
        //layout.itemSize.height = self.view.bounds.size.width / 1.5
        
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

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return stock != nil ? 18 : 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return section == 17 ? 1 : 2
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stockDataCell", for: indexPath) as! StockDataCollectionViewCell
        
        cell.setData(stock!.dataFields[(indexPath.section * 2) + indexPath.row])
        
        return cell
        
    }
    
}
