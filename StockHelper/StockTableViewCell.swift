//
//  StockTableViewCell.swift
//  StockHelper
//
//  Created by Victor Hong on 31/03/2017.
//  Copyright © 2017 Victor Hong. All rights reserved.
//

import UIKit

class StockTableViewCell: UITableViewCell {

    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    func setData(stockModel: StockModel) {
    
        symbolLabel.text = stockModel.symbol
        companyLabel.text = stockModel.name
        
        if let exchangeName = stockModel.exchangeName, let assetType = stockModel.assetType {
            infoLabel.text = exchangeName + "  |  " + assetType
        }
        
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
