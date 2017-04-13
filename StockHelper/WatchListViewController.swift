//
//  WatchListViewController.swift
//  StockHelper
//
//  Created by Victor Hong on 04/04/2017.
//  Copyright © 2017 Victor Hong. All rights reserved.
//

import UIKit

class WatchListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var arrayWL = ["IBM", "AMD", "AKER"]
    var watchList: [String: Stock]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        watchList = [String: Stock]()
        
        tableView.register(UINib(nibName: "StockWLDataTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "stockWLDataCell")
        for list in arrayWL {
            StockManager.fetchStockForSymbol(symbol: list, completion: { (stock) in
                self.watchList![list] = stock
                self.tableView.reloadData()
            })
        }
        
        
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

extension WatchListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayWL.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockWLDataCell", for: indexPath) as! StockWLDataTableViewCell
        
        if let stock = watchList?[arrayWL[indexPath.row]] {
            cell.setData(stock)
        } else {
            cell.symbolLabel.text = "Data still loading"
        }
        
        return cell
        
    }
    
}
