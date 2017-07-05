//
//  Constants.swift
//  StockHelper
//
//  Created by Victor Hong on 10/05/2017.
//  Copyright © 2017 Victor Hong. All rights reserved.
//

// MARK: - Constants
import Foundation

struct Constants {
    
    // MARK: refresh token
    
    struct Token {
        
        static var authorizedToken = "7ui-ao0AICEib3hEgUS6VBtro5Q-XoZu0"
        
    }
    
    // MARK: url
    
    struct URL {
        
        static let authorizedURL = "https://login.questrade.com/oauth2/token?grant_type=refresh_token&refresh_token=\(Constants.Token.authorizedToken)"
        
    }
    
    struct Headers {
        
        static let authorization = "Authorization"
    
    }
    
    struct Parameters {
        
        static let prefix = "prefix"
        static let ids = "ids"
        
    }
    
    struct MarketCalls {
        
        static let retriveSymbolWithID = "v1/symbols"
        static let retrieveSymbolWithSearch = "v1/symbols/search"
        static let retrieveMarketWithID = "v1/markets/quotes"
        
    }
    
}

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
