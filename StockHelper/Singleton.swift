//
//  Singleton.swift
//  StockHelper
//
//  Created by Victor Hong on 29/07/2017.
//  Copyright © 2017 Victor Hong. All rights reserved.
//

import Foundation
import Firebase

final class Singleton {
    
    static let sharedInstance = Singleton()
    
    var ref: FIRDatabaseReference?
    var userList: [String] = []
    var watchList: [String: AlphaStockStruct] = [String: AlphaStockStruct]()
    var user: FIRUser?
    var targetList: [String: Double] = [:]
    var arrayTarget: [String] = []
    
}
