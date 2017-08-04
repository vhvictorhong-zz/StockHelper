//
//  PriceChangeViewController.swift
//  StockHelper
//
//  Created by Victor Hong on 04/08/2017.
//  Copyright © 2017 Victor Hong. All rights reserved.
//

import UIKit

class PriceChangeViewController: UIViewController {
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceTextField: UITextField!
    var price: Double?
    var stockSymbol: String?
    
    let singleton = Singleton.sharedInstance
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let price = price {
            priceLabel.text = String(describing: price)
        }
                
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setTargetPriceAction(_ sender: Any) {
        
        guard let symbol = stockSymbol else {
            return
        }
        
        if priceTextField.text != "" {
            let price = Double(priceTextField.text!)
            singleton.ref?.child("user").child((singleton.user?.uid)!).child("targetList").updateChildValues([symbol: price ?? 0.0])
        }
        
        self.navigationController?.popViewController(animated: true)
        
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
