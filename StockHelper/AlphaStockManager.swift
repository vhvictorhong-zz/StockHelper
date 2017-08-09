//
//  AlphaStockManager.swift
//  StockHelper
//
//  Created by Victor Hong on 19/06/2017.
//  Copyright © 2017 Victor Hong. All rights reserved.
//

import UIKit
import Alamofire

struct AlphaStockStruct {
    
    var symbol: String?
    var exchangeName: String?
    var currentPrice: Double?
    var openPrice: Double?
    var highPrice: Double?
    var lowPrice: Double?
    var closePrice: Double?
    var priceChange: Double?
    var percentageChange: String?
    var volume: String?
    var lastUpdated: String?
    
}

class AlphaStockManager {
    
    // MARK: - fetchRealTimeStock
    
    class func fetchRealTimeStock(term: String, completion:@escaping (_ stockInfo: StockModel) -> ()) {
        
        DispatchQueue.global(qos: .default).async {
            
            let url = "http://www.alphavantage.co/query"
            
            Alamofire.request(url, parameters: ["function": "GLOBAL_QUOTE", "symbol": term, "apikey": "KAUQ"]).responseJSON(completionHandler: { (response) in
                
                if let resultJSON = response.result.value as? [String: AnyObject] {
                    
                    if let json = resultJSON["Realtime Global Securities Quote"] {
                        
                        guard let symbol = json["01. Symbol"] as? String,
                            let exchangeName = json["02. Exchange Name"] as? String,
                            let currentPrice = json["03. Latest Price"] as? String,
                            let openPrice = json["04. Open (Current Trading Day)"] as? String,
                            let highPrice = json["05. High (Current Trading Day)"] as? String,
                            let lowPrice = json["06. Low (Current Trading Day)"] as? String,
                            let closePrice = json["07. Close (Previous Trading Day)"] as? String,
                            let priceChange = json["08. Price Change"] as? String,
                            let percentageChange = json["09. Price Change Percentage"] as? String,
                            let volume = json["10. Volume (Current Trading Day)"] as? String,
                            let lastUpdated = json["11. Last Updated"] as? String else {
                                return
                        }
                        
                        let stockInfo = StockModel.init(withAlphaRealTime: symbol, exchangeName: exchangeName, currentPrice: Double(currentPrice)!, openPrice: Double(openPrice)!, highPrice: Double(highPrice)!, lowPrice: Double(lowPrice)!, closePrice: Double(closePrice)!, priceChange: Double(priceChange)!, percentageChange: percentageChange, volume: volume, lastUpdated: lastUpdated)
                        
                        DispatchQueue.main.async {
                            completion(stockInfo)
                        }
                    }
                }
            })
        }
    }
    
    class func fetchStocksFromSearch(term: String, completion:@escaping (_ stockInfoArray: [StockModel]) -> ()) {
        
        DispatchQueue.global(qos: .default).async {
            
            let searchURL = "http://autoc.finance.yahoo.com/autoc"
            
            Alamofire.request(searchURL, parameters: ["query": term, "region": 2, "lang": "en"]).responseJSON { response in
                
                if let resultJSON = response.result.value as? [String : AnyObject]  {
                    
                    if let jsonArray = (resultJSON["ResultSet"] as! [String : AnyObject])["Result"] as? [[String : String]] {
                        
                        var stockInfoArray = [StockModel]()
                        for dictionary in jsonArray {
                            guard let symbol = dictionary["symbol"],
                                let name = dictionary["name"],
                                let exchangeName = dictionary["exchDisp"],
                                let assetType = dictionary["typeDisp"] else {
                                    return
                                    
                            }
                            stockInfoArray.append(StockModel.init(withSearhResult: symbol, name: name, exchangeName: exchangeName, assetType: assetType))
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
    
    class func fetchStockForSymbol(symbol: String, completion:@escaping (_ stock: StockModel) -> ()) {
        
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
                        
                        guard let ask = ["Ask" : stockData["Ask"] as? String ?? "N/A"].values.first,
                            let averageDailyVolume = ["Average Daily Volume" : stockData["AverageDailyVolume"] as? String ?? "N/A"].values.first,
                            let bid = ["Bid" : stockData["Bid"] as? String ?? "N/A"].values.first,
                            let bookValue = ["Book Value" : stockData["BookValue"] as? String ?? "N/A"].values.first,
                            let changeNumeric = ["Change" : stockData["Change"] as? String ?? "N/A"].values.first,
                            let changePercent = ["Percent Change" : stockData["ChangeinPercent"] as? String ?? "N/A"].values.first,
                            let dayHigh = ["Day High" : stockData["DaysHigh"] as? String ?? "N/A"].values.first,
                            let dayLow = ["Day Low" : stockData["DaysLow"] as? String ?? "N/A"].values.first,
                            let dividendShare = ["Div/Share" : stockData["DividendShare"] as? String ?? "N/A"].values.first,
                            let dividendYield = ["Div Yield" : stockData["DividendYield"] as? String ?? "N/A"].values.first,
                            let ebitda = ["EBITDA" : stockData["EBITDA"] as? String ?? "N/A"].values.first,
                            let epsEstimateCurrentYear = ["Current Yr EPS Estimate" : stockData["EPSEstimateCurrentYear"] as? String ?? "N/A"].values.first,
                            let epsEstimateNextQtr = ["Next Qtr EPS Estimate" : stockData["EPSEstimateNextQuarter"] as? String ?? "N/A"].values.first,
                            let epsEstimateNextYr = ["Next Yr EPS Estimate" : stockData["EPSEstimateNextYear"] as? String ?? "N/A"].values.first,
                            let eps = ["Earnings/Share" : stockData["EarningsShare"] as? String ?? "N/A"].values.first,
                            let fiftydayMovingAverage = ["50D MA" : stockData["FiftydayMovingAverage"] as? String ?? "N/A"].values.first,
                            let lastTradeDate = ["Last Trade Date" : stockData["LastTradeDate"] as? String ?? "N/A"].values.first,
                            let last = ["Last" : stockData["LastTradePriceOnly"] as? String ?? "N/A"].values.first,
                            let lastTradeTime = ["Last Trade Time" : stockData["LastTradeTime"] as? String ?? "N/A"].values.first,
                            let lastTradePrice = ["Last Trade Price" : stockData["LastTradePriceOnly"] as? String ?? "N/A"].values.first,
                            let marketCap = ["Market Cap" : stockData["MarketCapitalization"] as? String ?? "N/A"].values.first,
                            let companyName = ["Company" : stockData["Name"] as? String ?? "N/A"].values.first,
                            let oneYearTarget = ["One Yr Target" : stockData["OneyrTargetPrice"] as? String ?? "N/A"].values.first,
                            let open = ["Open" : stockData["Open"] as? String ?? "N/A"].values.first,
                            let pegRatio = ["PEG Ratio" : stockData["PEGRatio"] as? String ?? "N/A"].values.first,
                            let peRatio = ["PE Ratio" : stockData["PERatio"] as? String ?? "N/A"].values.first,
                            let previousClose = ["Previous Close" : stockData["PreviousClose"] as? String ?? "N/A"].values.first,
                            let priceBook = ["Price-Book" : stockData["PriceBook"] as? String ?? "N/A"].values.first,
                            let priceSales = ["Price-Sales" : stockData["PriceSales"] as? String ?? "N/A"].values.first,
                            let shortRatio = ["Short Ratio" : stockData["ShortRatio"] as? String ?? "N/A"].values.first,
                            let stockExchange = ["Stock Exchange" : stockData["StockExchange"] as? String ?? "N/A"].values.first,
                            let symbol = ["Symbol" : stockData["Symbol"] as? String ?? "N/A"].values.first,
                            let twoHundreddayMovingAverage = ["200D MA" : stockData["TwoHundreddayMovingAverage"] as? String ?? "N/A"].values.first,
                            let volume = ["Volume" : stockData["Volume"] as? String ?? "N/A"].values.first,
                            let yearHigh = ["52w High" : stockData["YearHigh"] as? String ?? "N/A"].values.first,
                            let yearLow = ["52w Low" : stockData["YearLow"] as? String ?? "N/A"].values.first else {
                                return
                        }
                        
                        
                        let stock = StockModel.init(withYahooStock: ask, averageDailyVolume: averageDailyVolume, bid: bid, bookValue: bookValue, changeNumeric: changeNumeric, changePercent: changePercent, dayHigh: dayHigh, dayLow: dayLow, dividendShare: dividendShare, dividendYield: dividendYield, ebitda: ebitda, epsEstimateCurrentYear: epsEstimateCurrentYear, epsEstimateNextQtr: epsEstimateNextQtr, epsEstimateNextYr: epsEstimateNextYr, eps: eps, fiftydayMovingAverage: fiftydayMovingAverage, lastTradeDate: lastTradeDate, last: last, lastTradeTime: lastTradeTime, lastTradePrice: lastTradePrice, marketCap: marketCap, companyName: companyName, oneYearTarget: oneYearTarget, open: open, pegRatio: pegRatio, peRatio: peRatio, previousClose: previousClose, priceBook: priceBook, priceSales: priceSales, shortRatio: shortRatio, stockExchange: stockExchange, symbol: symbol, twoHundreddayMovingAverage: twoHundreddayMovingAverage, volume: volume, yearHigh: yearHigh, yearLow: yearLow, dataFields: dataFields)
//                        let stock = StockStruct(
//                            ask: dataFields[0].values.first,
//                            averageDailyVolume: dataFields[1].values.first,
//                            bid: dataFields[2].values.first,
//                            bookValue: dataFields[3].values.first,
//                            changeNumeric: dataFields[4].values.first,
//                            changePercent: dataFields[5].values.first,
//                            dayHigh: dataFields[6].values.first,
//                            dayLow: dataFields[7].values.first,
//                            dividendShare: dataFields[8].values.first,
//                            dividendYield: dataFields[9].values.first,
//                            ebitda: dataFields[10].values.first,
//                            epsEstimateCurrentYear: dataFields[11].values.first,
//                            epsEstimateNextQtr: dataFields[12].values.first,
//                            epsEstimateNextYr: dataFields[13].values.first,
//                            eps: dataFields[14].values.first,
//                            fiftydayMovingAverage: dataFields[15].values.first,
//                            lastTradeDate: dataFields[16].values.first,
//                            last: dataFields[17].values.first,
//                            lastTradeTime: dataFields[18].values.first,
//                            lastTradePrice: dataFields[19].values.first,
//                            marketCap: dataFields[20].values.first,
//                            companyName: dataFields[21].values.first,
//                            oneYearTarget: dataFields[22].values.first,
//                            open: dataFields[23].values.first,
//                            pegRatio: dataFields[24].values.first,
//                            peRatio: dataFields[25].values.first,
//                            previousClose: dataFields[26].values.first,
//                            priceBook: dataFields[27].values.first,
//                            priceSales: dataFields[28].values.first,
//                            shortRatio: dataFields[29].values.first,
//                            stockExchange: dataFields[30].values.first,
//                            symbol: dataFields[31].values.first,
//                            twoHundreddayMovingAverage: dataFields[32].values.first,
//                            volume: dataFields[33].values.first,
//                            yearHigh: dataFields[34].values.first,
//                            yearLow: dataFields[35].values.first,
//                            dataFields: dataFields
//                        )
                        
                        DispatchQueue.main.async {
                            completion(stock)
                        }
                    }
                }
            }
        }
    }
    
    
}
