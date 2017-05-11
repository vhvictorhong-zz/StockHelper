//
//  Constants.swift
//  StockHelper
//
//  Created by Victor Hong on 10/05/2017.
//  Copyright © 2017 Victor Hong. All rights reserved.
//

// MARK: - Constants

struct Constants {
    
    // MARK: refresh token
    
    struct Token {
        
        static let authorizedToken = "k9_ZemoA6Mbl45-TKlosT3fvlY8Xw7080"
        
    }
    
    // MARK: url
    
    struct URL {
        
        static let authorizedURL = "https://login.questrade.com/oauth2/token?grant_type=refresh_token&refresh_token=\(Constants.Token.authorizedToken)"
        
        
    }
    
    struct MarketCalls {
        
        static let retriveStocksWithID = "v1/symbols"
        static let retrieveStockWithSearch = "v1/symbols/search"
        
    }
    
}
