//
//  TargetCollectionViewCell.swift
//  StockHelper
//
//  Created by Victor Hong on 28/07/2017.
//  Copyright © 2017 Victor Hong. All rights reserved.
//

import UIKit

class TargetCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var targetView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var targetLabel: UILabel!
    
    let singleton = Singleton.sharedInstance
    
    func setData(alphaStock: String, targetList: [String: Double]) {
        
        targetView.layer.borderColor = UIColor.black.cgColor
        targetView.layer.borderWidth = 1
        
        guard var currentPrice = singleton.watchList[alphaStock]?.currentPrice else {
            return
        }
        guard var targetPrice = targetList[alphaStock] else {
            return
        }
        
        targetPrice = Double(targetPrice).roundTo(places: 2)
        currentPrice = Double(currentPrice).roundTo(places: 2)
        
        if targetPrice < currentPrice {
            targetView.backgroundColor = .green
        } else {
            targetView.backgroundColor = .red
        }
        
        nameLabel.text = singleton.watchList[alphaStock]?.symbol
        priceLabel.text = String(describing: currentPrice)
        targetLabel.text = String(describing: targetPrice)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
