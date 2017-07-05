//
//  StockListCollectionViewCell.swift
//  StockHelper
//
//  Created by Victor Hong on 09/05/2017.
//  Copyright © 2017 Victor Hong. All rights reserved.
//

import UIKit

class StockListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var stockListView: UIView!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var amountChangeLabel: UILabel!
    @IBOutlet weak var percentageChangeLabel: UILabel!
    
    func setData(_ stockData: AlphaStock) {
        
        let currentPrice = Double(stockData.currentPrice!).roundTo(places: 2)
        let priceChange = Double(stockData.priceChange!).roundTo(places: 2)
        
        companyLabel.text = stockData.symbol
        priceLabel.text = String(describing: currentPrice)
        amountChangeLabel.text = String(describing: priceChange)
        //percentageChangeLabel.text = stockData.percentageChange
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

}
