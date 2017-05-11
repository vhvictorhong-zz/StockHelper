//
//  QTStockManager.swift
//  StockHelper
//
//  Created by Victor Hong on 10/05/2017.
//  Copyright © 2017 Victor Hong. All rights reserved.
//

import Foundation
import Alamofire

struct AcessToken {
    
    var accessToken = ""
    static var api_server = "https://api07.iq.questrade.com/"
    var expires_in = ""
    var token_type = ""
}

struct Stock {
    
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

struct StockDetail {
    
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

struct StockSearch {
    
    var symbol: String?
    var symbolID: Int?
    var description: String?
    var listingExchange: String?
    var currency: String?
    
}

struct MarketQuote {
    
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
    
}

class QTStockManager {
    
    // MARK: - fetchStocksFromSearch
    
    class func fetchStocksFromSearch(term: String, completion:@escaping (_ stockInfoArray: [StockSearch]) -> ()) {
        
        DispatchQueue.global(qos: .default).async {
            
            let searchURL = AcessToken.api_server + Constants.MarketCalls.retrieveStockWithSearch
            
            Alamofire.request(searchURL, parameters: ["prefix": term], headers: ["Authorization": "Bearer SCklMBcOs6uCLMr3Hd9YoABECcNmjOKs0"]).responseJSON(completionHandler: { (response) in
                
                if let resultJSON = response.result.value as? [String : AnyObject] {
                    
                    if let jsonArray = resultJSON["symbols"] as? [[String: AnyObject]]{
                        
                        var stockInfoArray = [StockSearch]()
                        
                        for dictionary in jsonArray {
                            stockInfoArray.append(StockSearch(symbol: dictionary["symbol"] as? String, symbolID: dictionary["symbolId"] as? Int, description: dictionary["description"] as? String, listingExchange: dictionary["listingExchange"] as? String, currency: dictionary["currency"] as? String))
                        }
                        
                        DispatchQueue.main.async {
                            completion(stockInfoArray)
                        }
                    }
                }
            })
        }
    }
    
    // MARK: - fetchStockDetail
    
    class func fetchStockDetail(id: Int, completion:@escaping (_ stockInfo: StockDetail) -> ()) {
        
        DispatchQueue.global(qos: .default).async {
            
            let stockURL = AcessToken.api_server + Constants.MarketCalls.retriveStocksWithID
            
            Alamofire.request(stockURL, parameters: ["ids": id], headers: ["Authorization": "Bearer AxIXcnsKawCR__n7ZIQB76yJkfCyCjvQ0"]).responseJSON(completionHandler: { (response) in
                
                if let resultJSON = response.result.value as? [String: AnyObject] {
                    
                    var stockInfo = StockDetail()
                    if let json = resultJSON["symbols"] as? [[String: AnyObject]] {
                        
                        for dictionary in json {
                            stockInfo = StockDetail(symbol: dictionary["symbol"] as? String, symbolID: dictionary["symbolId"] as? Int, prevDayClosePrice: dictionary["prevDayClosePrice"] as? Double, highPrice52: dictionary["highPrice52"] as? Double, lowPrice52: dictionary["lowPrice52"] as? Double, averageVol3Months: dictionary["averageVol3Months"] as? Int, averageVol20Days: dictionary["averageVol20Days"] as? Int, outstandingShares: dictionary["outstandingShares"] as? Int, eps: dictionary["eps"] as? Double, pe: dictionary["pe"] as? Double, dividend: dictionary["dividend"] as? Double, yield: dictionary["yield"] as? Double, marketCap: dictionary["marketCap"] as? Double, listingExchange: dictionary["listingExchange"] as? String, description: dictionary["description"] as? String, currency: dictionary["currency"] as? String, industrySector: dictionary["industrySector"] as? String, industryGroup: dictionary["industryGroup"] as? String, industrySubGroup: dictionary["industrySubGroup"] as? String)
                        }
                        
                        DispatchQueue.main.async {
                            completion(stockInfo)
                        }
                    }
                    
                    //print(resultJSON["symbols"] as? )
                    
                }
            })
        }
    }

}
