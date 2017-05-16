//
//  StockListViewController.swift
//  StockHelper
//
//  Created by Victor Hong on 09/05/2017.
//  Copyright © 2017 Victor Hong. All rights reserved.
//

import UIKit

class StockListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        collectionView.register(UINib(nibName: "StockListCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "stockListCell")
        
        
    }
    
    override func viewDidLayoutSubviews() {
        
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { fatalError("Expected the collection view to have a UICollectionViewFlowLayout") }
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize.width = self.view.bounds.size.width / 4
        layout.itemSize.height = self.view.bounds.size.height / 10
        
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

extension StockListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
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
        
        cell?.companyLabel.text = "\(indexPath.row)"
        
        return cell!
        
    }
    
}
