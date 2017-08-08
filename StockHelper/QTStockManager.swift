//
//  QTStockManager.swift
//  StockHelper
//
//  Created by Victor Hong on 10/05/2017.
//  Copyright © 2017 Victor Hong. All rights reserved.
//

import Foundation
import Alamofire

struct AccessToken {
    
    var accessToken = ""
    var api_server = ""
    var expires_in = 0
    var refresh_token = ""
    var token_type = ""
}

struct StockStruct {
    
    var ask: String?
    var averageDailyVolume: String?
    var bid: String?
    var bookValue: String?
    var changeNumeric: String?
    var changePercent: String?
    var dayHigh: String?
    var dayLow: String?
    var dividendShare: String?
    var dividendYield: String?
    var ebitda: String?
    var epsEstimateCurrentYear: String?
    var epsEstimateNextQtr: String?
    var epsEstimateNextYr: String?
    var eps: String?
    var fiftydayMovingAverage: String?
    var lastTradeDate: String?
    var last: String?
    var lastTradeTime: String?
    var lastTradePrice: String?
    var marketCap: String?
    var companyName: String?
    var oneYearTarget: String?
    var open: String?
    var pegRatio: String?
    var peRatio: String?
    var previousClose: String?
    var priceBook: String?
    var priceSales: String?
    var shortRatio: String?
    var stockExchange: String?
    var symbol: String?
    var twoHundreddayMovingAverage: String?
    var volume: String?
    var yearHigh: String?
    var yearLow: String?
    
    var dataFields: [[String : String]]
    
}

struct StockDetailStruct {
    
    var symbol: String?
    var symbolID: Int?
    var prevDayClosePrice: Double?
    var highPrice52: Double?
    var lowPrice52: Double?
    var averageVol3Months: Int?
    var averageVol20Days: Int?
    var outstandingShares: Int?
    var eps: Double?
    var pe: Double?
    var dividend: Double?
    var yield: Double?
    var marketCap: Double?
    var listingExchange: String?
    var description: String?
    var currency: String?
    var industrySector: String?
    var industryGroup: String?
    var industrySubGroup: String?
    
}

struct StockSearchStruct {
    
    var symbol: String?
    var symbolID: Int?
    var description: String?
    var listingExchange: String?
    var currency: String?
    
}

struct MarketQuoteStruct {
    
    var symbol: String?
    var symbolID: Int?
    var bidPrice: Double?
    var bidSize: Int?
    var askPrice: Double?
    var askSize: Int?
    var lastTradeTrHrs: Double?
    var lastTradePrice: Double?
    var lastTradeSize: Double?
    var volume: Int?
    var openPrice: Double?
    var highPrice: Double?
    var lowPrice: Double?
    var delay: Double?
    
}

class QTStockManager {
    
    // MARK: - fetchSymbolsFromSearch
    
    class func fetchSymbolsFromSearch(term: String, completion:@escaping (_ stockInfoArray: [StockSearchStruct]) -> ()) {
        
        DispatchQueue.global(qos: .default).async {
            
            let searchURL = "https://api07.iq.questrade.com/" + Constants.MarketCalls.retrieveSymbolWithSearch
            
            Alamofire.request(searchURL, parameters: [Constants.Parameters.prefix: term], headers: [Constants.Headers.authorization: "Bearer SCklMBcOs6uCLMr3Hd9YoABECcNmjOKs0"]).responseJSON(completionHandler: { (response) in
                
                if let resultJSON = response.result.value as? [String : AnyObject] {
                    
                    if let jsonArray = resultJSON["symbols"] as? [[String: AnyObject]]{
                        
                        var stockInfoArray = [StockStruct]()
                        
//                        for dictionary in jsonArray {
//                            stockInfoArray.append(StockStruct(symbol: dictionary["symbol"] as? String, symbolID: dictionary["symbolId"] as? Int, description: dictionary["description"] as? String, listingExchange: dictionary["listingExchange"] as? String, currency: dictionary["currency"] as? String, bookValue: dictionary["bookValue"], changeNumeric: <#String?#>))
//                        }
//                        
                        DispatchQueue.main.async {
//                            completion(stockInfoArray)
                        }
                    }
                }
            })
        }
    }
    
    // MARK: - fetchSymbolDetail
    
    class func fetchSymbolDetail(id: Int, completion:@escaping (_ stockInfo: StockDetailStruct) -> ()) {
        
        DispatchQueue.global(qos: .default).async {
            
            let stockURL = "https://api07.iq.questrade.com/" + Constants.MarketCalls.retriveSymbolWithID
            
            Alamofire.request(stockURL, parameters: [Constants.Parameters.ids: id], headers: [Constants.Headers.authorization: "Bearer AxIXcnsKawCR__n7ZIQB76yJkfCyCjvQ0"]).responseJSON(completionHandler: { (response) in
                
                if let resultJSON = response.result.value as? [String: AnyObject] {
                    
                    var stockInfo = StockDetailStruct()
                    if let json = resultJSON["symbols"] as? [[String: AnyObject]] {
                        
                        for dictionary in json {
                            stockInfo = StockDetailStruct(symbol: dictionary["symbol"] as? String, symbolID: dictionary["symbolId"] as? Int, prevDayClosePrice: dictionary["prevDayClosePrice"] as? Double, highPrice52: dictionary["highPrice52"] as? Double, lowPrice52: dictionary["lowPrice52"] as? Double, averageVol3Months: dictionary["averageVol3Months"] as? Int, averageVol20Days: dictionary["averageVol20Days"] as? Int, outstandingShares: dictionary["outstandingShares"] as? Int, eps: dictionary["eps"] as? Double, pe: dictionary["pe"] as? Double, dividend: dictionary["dividend"] as? Double, yield: dictionary["yield"] as? Double, marketCap: dictionary["marketCap"] as? Double, listingExchange: dictionary["listingExchange"] as? String, description: dictionary["description"] as? String, currency: dictionary["currency"] as? String, industrySector: dictionary["industrySector"] as? String, industryGroup: dictionary["industryGroup"] as? String, industrySubGroup: dictionary["industrySubGroup"] as? String)
                        }
                        
                        DispatchQueue.main.async {
                            completion(stockInfo)
                        }
                        
                    }
                }
            })
        }
    }
    
    // MARK: - fetchMarketWithID
    
    class func fetchMarketID(id: Int, completion:@escaping (_ marketInfo: MarketQuoteStruct) -> ()) {
        
        DispatchQueue.global(qos: .default).async {
            
            let marketURL = "https://api07.iq.questrade.com/" + Constants.MarketCalls.retrieveMarketWithID
            
            Alamofire.request(marketURL, parameters: [Constants.Parameters.ids: id], headers: [Constants.Headers.authorization: "Bearer AxIXcnsKawCR__n7ZIQB76yJkfCyCjvQ0"]).responseJSON(completionHandler: { (response) in
                
                if let resultJSON = response.result.value as? [String: AnyObject] {
                    
                    var marketInfo = MarketQuoteStruct()
                    if let json = resultJSON["quotes"] as? [[String: AnyObject]] {
                        
                        for dictionary in json {
                            marketInfo = MarketQuoteStruct(symbol: dictionary["symbol"] as? String, symbolID: dictionary["symbolId"] as? Int, bidPrice: dictionary["bidPrice"] as? Double, bidSize: dictionary["bidSize"] as? Int, askPrice: dictionary["askPrice"] as? Double, askSize: dictionary["askSize"] as? Int, lastTradeTrHrs: dictionary["lastTradeTrHrs"] as? Double, lastTradePrice: dictionary["lastTradePrice"] as? Double, lastTradeSize: dictionary["lastTradeSize"] as? Double, volume: dictionary["volume"] as? Int, openPrice: dictionary["openPrice"] as? Double, highPrice: dictionary["highPrice"] as? Double, lowPrice: dictionary["lowPrice"] as? Double, delay: dictionary["delay"] as? Double)
                        }
                        
                        DispatchQueue.main.async {
                            completion(marketInfo)
                        }
                        
                    }
                }
            })
        }
    }
    
    // MARK - fetchRefreshToken
    
    class func fetchRefreshToken(completion:@escaping (_ refreshInfo: AccessToken) -> ()) {
        
        DispatchQueue.global(qos: .default).async {
            
            let refreshURL = Constants.URL.authorizedURL
            
            Alamofire.request(refreshURL).responseJSON(completionHandler: { (response) in
                
                if let resultJSON = response.result.value as? [String: AnyObject] {
                    
                    guard let accessToken = resultJSON["access_token"] as? String else {
                        return
                    }
                    
                    guard let api_server = resultJSON["api_server"] as? String else {
                        return
                    }
                    
                    guard let expires_in = resultJSON["expires_in"] as? Int else {
                        return
                    }
                    
                    guard let refresh_token = resultJSON["refresh_token"] as? String else {
                        return
                    }
                    
                    guard let token_type = resultJSON["token_type"] as? String else {
                        return
                    }
                    
                    let refreshInfo = AccessToken(accessToken: accessToken, api_server: api_server, expires_in: expires_in, refresh_token: refresh_token, token_type: token_type)
                    
                    DispatchQueue.main.async {
                        completion(refreshInfo)
                    }
                    
                }
            })
        }
    }

}
