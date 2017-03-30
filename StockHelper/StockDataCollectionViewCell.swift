//
//  StockDataCollectionViewCell.swift
//  StockHelper
//
//  Created by Victor Hong on 29/03/2017.
//  Copyright © 2017 Victor Hong. All rights reserved.
//

import UIKit

class StockDataCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    func setData(_ data: [String : String]) {
        
        nameLabel.text = data.keys.first
        valueLabel.text = data.values.first
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
