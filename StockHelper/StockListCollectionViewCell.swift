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
    
    func setData(_ stockData: AlphaStockStruct) {
        
        stockListView.layer.borderColor = UIColor.black.cgColor
        stockListView.layer.borderWidth = 1
        
        let currentPrice = Double(stockData.currentPrice!).roundTo(places: 2)
        let priceChange = Double(stockData.priceChange!).roundTo(places: 2)
        
        companyLabel.text = stockData.symbol
        priceLabel.text = String(describing: currentPrice)
        amountChangeLabel.text = String(describing: priceChange)
        
        if (priceChange >= 0) {
            stockListView.backgroundColor = .green
        } else {
            stockListView.backgroundColor = .red
        }
        
        percentageChangeLabel.text = stockData.percentageChange
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

}
