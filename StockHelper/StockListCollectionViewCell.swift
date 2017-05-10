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
    @IBOutlet weak var amountChangeLabel: UILabel!
    @IBOutlet weak var percentageChangeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

}
