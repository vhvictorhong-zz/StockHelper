//
//  StockManager.swift
//  StockHelper
//
//  Created by Victor Hong on 30/03/2017.
//  Copyright © 2017 Victor Hong. All rights reserved.
//

import UIKit
import Alamofire

struct StockSearchResult {
    var symbol: String?
    var name: String?
    var exchange: String?
    var assetType: String?
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

class StockManager {
    
// MARK: - fetchStocksFromSearch
    
    class func fetchStocksFromSearch(term: String, completion:@escaping (_ stockInfoArray: [StockSearchResult]) -> ()) {
        
        DispatchQueue.global(qos: .default).async {
            
            let searchURL = "http://autoc.finance.yahoo.com/autoc"
            
            Alamofire.request(searchURL, parameters: ["query": term, "region": 2, "lang": "en"]).responseJSON { response in
                
                if let resultJSON = response.result.value as? [String : AnyObject]  {
                    
                    if let jsonArray = (resultJSON["ResultSet"] as! [String : AnyObject])["Result"] as? [[String : String]] {
                        
                        var stockInfoArray = [StockSearchResult]()
                        for dictionary in jsonArray {
                            stockInfoArray.append(StockSearchResult(symbol: dictionary["symbol"], name: dictionary["name"], exchange: dictionary["exchDisp"], assetType: dictionary["typeDisp"]))
                        }
                        
                        DispatchQueue.main.async {
                            completion(stockInfoArray)
                        }
                    }
                }
            }
        }
    }

    
// MARK: - fetchStockForSymbol
    
    class func fetchStockForSymbol(symbol: String, completion:@escaping (_ stock: Stock) -> ()) {
        
        DispatchQueue.global(qos: .default).async {
            
            let stockURL = "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22\(symbol)%22)&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&format=json"
            
            Alamofire.request(stockURL).responseJSON { response in
                
                if let resultJSON = response.result.value as? [String : AnyObject]  {
                    
                    if let stockData = ((resultJSON["query"] as! [String : AnyObject])["results"] as! [String : AnyObject])["quote"] as? [String : AnyObject] {
                        
                        // lengthy creation, yeah
                        var dataFields = [[String : String]]()
                        
                        dataFields.append(["Ask" : stockData["Ask"] as? String ?? "N/A"])
                        dataFields.append(["Average Daily Volume" : stockData["AverageDailyVolume"] as? String ?? "N/A"])
                        dataFields.append(["Bid" : stockData["Bid"] as? String ?? "N/A"])
                        dataFields.append(["Book Value" : stockData["BookValue"] as? String ?? "N/A"])
                        dataFields.append(["Change" : stockData["Change"] as? String ?? "N/A"])
                        dataFields.append(["Percent Change" : stockData["ChangeinPercent"] as? String ?? "N/A"])
                        dataFields.append(["Day High" : stockData["DaysHigh"] as? String ?? "N/A"])
                        dataFields.append(["Day Low" : stockData["DaysLow"] as? String ?? "N/A"])
                        dataFields.append(["Div/Share" : stockData["DividendShare"] as? String ?? "N/A"])
                        dataFields.append(["Div Yield" : stockData["DividendYield"] as? String ?? "N/A"])
                        dataFields.append(["EBITDA" : stockData["EBITDA"] as? String ?? "N/A"])
                        dataFields.append(["Current Yr EPS Estimate" : stockData["EPSEstimateCurrentYear"] as? String ?? "N/A"])
                        dataFields.append(["Next Qtr EPS Estimate" : stockData["EPSEstimateNextQuarter"] as? String ?? "N/A"])
                        dataFields.append(["Next Yr EPS Estimate" : stockData["EPSEstimateNextYear"] as? String ?? "N/A"])
                        dataFields.append(["Earnings/Share" : stockData["EarningsShare"] as? String ?? "N/A"])
                        dataFields.append(["50D MA" : stockData["FiftydayMovingAverage"] as? String ?? "N/A"])
                        dataFields.append(["Last Trade Date" : stockData["LastTradeDate"] as? String ?? "N/A"])
                        dataFields.append(["Last" : stockData["LastTradePriceOnly"] as? String ?? "N/A"])
                        dataFields.append(["Last Trade Time" : stockData["LastTradeTime"] as? String ?? "N/A"])
                        dataFields.append(["Last Trade Price" : stockData["LastTradePriceOnly"] as? String ?? "N/A"])
                        dataFields.append(["Market Cap" : stockData["MarketCapitalization"] as? String ?? "N/A"])
                        dataFields.append(["Company" : stockData["Name"] as? String ?? "N/A"])
                        dataFields.append(["One Yr Target" : stockData["OneyrTargetPrice"] as? String ?? "N/A"])
                        dataFields.append(["Open" : stockData["Open"] as? String ?? "N/A"])
                        dataFields.append(["PEG Ratio" : stockData["PEGRatio"] as? String ?? "N/A"])
                        dataFields.append(["PE Ratio" : stockData["PERatio"] as? String ?? "N/A"])
                        dataFields.append(["Previous Close" : stockData["PreviousClose"] as? String ?? "N/A"])
                        dataFields.append(["Price-Book" : stockData["PriceBook"] as? String ?? "N/A"])
                        dataFields.append(["Price-Sales" : stockData["PriceSales"] as? String ?? "N/A"])
                        dataFields.append(["Short Ratio" : stockData["ShortRatio"] as? String ?? "N/A"])
                        dataFields.append(["Stock Exchange" : stockData["StockExchange"] as? String ?? "N/A"])
                        dataFields.append(["Symbol" : stockData["Symbol"] as? String ?? "N/A"])
                        dataFields.append(["200D MA" : stockData["TwoHundreddayMovingAverage"] as? String ?? "N/A"])
                        dataFields.append(["Volume" : stockData["Volume"] as? String ?? "N/A"])
                        dataFields.append(["52w High" : stockData["YearHigh"] as? String ?? "N/A"])
                        dataFields.append(["52w Low" : stockData["YearLow"] as? String ?? "N/A"])
                        
                        let stock = Stock(
                            ask: dataFields[0].values.first,
                            averageDailyVolume: dataFields[1].values.first,
                            bid: dataFields[2].values.first,
                            bookValue: dataFields[3].values.first,
                            changeNumeric: dataFields[4].values.first,
                            changePercent: dataFields[5].values.first,
                            dayHigh: dataFields[6].values.first,
                            dayLow: dataFields[7].values.first,
                            dividendShare: dataFields[8].values.first,
                            dividendYield: dataFields[9].values.first,
                            ebitda: dataFields[10].values.first,
                            epsEstimateCurrentYear: dataFields[11].values.first,
                            epsEstimateNextQtr: dataFields[12].values.first,
                            epsEstimateNextYr: dataFields[13].values.first,
                            eps: dataFields[14].values.first,
                            fiftydayMovingAverage: dataFields[15].values.first,
                            lastTradeDate: dataFields[16].values.first,
                            last: dataFields[17].values.first,
                            lastTradeTime: dataFields[18].values.first,
                            lastTradePrice: dataFields[19].values.first,
                            marketCap: dataFields[20].values.first,
                            companyName: dataFields[21].values.first,
                            oneYearTarget: dataFields[22].values.first,
                            open: dataFields[23].values.first,
                            pegRatio: dataFields[24].values.first,
                            peRatio: dataFields[25].values.first,
                            previousClose: dataFields[26].values.first,
                            priceBook: dataFields[27].values.first,
                            priceSales: dataFields[28].values.first,
                            shortRatio: dataFields[29].values.first,
                            stockExchange: dataFields[30].values.first,
                            symbol: dataFields[31].values.first,
                            twoHundreddayMovingAverage: dataFields[32].values.first,
                            volume: dataFields[33].values.first,
                            yearHigh: dataFields[34].values.first,
                            yearLow: dataFields[35].values.first,
                            dataFields: dataFields
                        )
                        
                        DispatchQueue.main.async {
                            completion(stock)
                        }
                    }
                }
            }
        }
    }

    
}
