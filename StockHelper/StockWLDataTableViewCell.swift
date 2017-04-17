//
//  StockWLDataTableViewCell.swift
//  StockHelper
//
//  Created by Victor Hong on 04/04/2017.
//  Copyright © 2017 Victor Hong. All rights reserved.
//

import UIKit

class StockWLDataTableViewCell: UITableViewCell {

    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var percentChangeLabel: UILabel!
    
    func setData(_ stockData: Stock) {
        
        symbolLabel.text = stockData.symbol
        companyLabel.text = stockData.companyName
        //priceLabel.text = stockData.lastTrad
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
