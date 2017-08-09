//
//  StockModel.swift
//  StockHelper
//
//  Created by Victor Hong on 08/08/2017.
//  Copyright © 2017 Victor Hong. All rights reserved.
//

import Foundation

class StockModel: NSObject {
    
    // alpha real time
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
    
    //StockSearchResultStruct
//    var symbol: String?
    var name: String?
//    var exchange: String?
    var assetType: String?
    
    //Stockyahoo
    
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
//    var symbol: String?
    var twoHundreddayMovingAverage: String?
//    var volume: String?
    var yearHigh: String?
    var yearLow: String?
    var dataFields: [[String: String]]?
    
    init(withAlphaRealTime symbol: String, exchangeName: String, currentPrice: Double, openPrice: Double, highPrice: Double, lowPrice: Double, closePrice: Double, priceChange: Double, percentageChange: String, volume: String, lastUpdated: String) {
        
        self.symbol = symbol
        self.exchangeName = exchangeName
        self.currentPrice = currentPrice
        self.openPrice = openPrice
        self.highPrice = highPrice
        self.lowPrice = lowPrice
        self.closePrice = closePrice
        self.priceChange = priceChange
        self.percentageChange = percentageChange
        self.volume = volume
        self.lastUpdated = lastUpdated
        
    }
    
    init(withSearhResult symbol: String, name: String, exchangeName: String, assetType: String) {
        
        self.symbol = symbol
        self.name = name
        self.exchangeName = exchangeName
        self.assetType = assetType
        
    }
    
    init(withYahooStock ask: String, averageDailyVolume: String, bid: String, bookValue: String, changeNumeric: String, changePercent: String, dayHigh: String, dayLow: String, dividendShare: String, dividendYield: String, ebitda: String, epsEstimateCurrentYear: String, epsEstimateNextQtr: String, epsEstimateNextYr: String, eps: String, fiftydayMovingAverage: String, lastTradeDate: String, last: String, lastTradeTime: String, lastTradePrice: String, marketCap: String, companyName: String, oneYearTarget: String, open: String, pegRatio: String, peRatio: String, previousClose: String, priceBook: String, priceSales: String, shortRatio: String, stockExchange: String, symbol: String, twoHundreddayMovingAverage: String, volume: String, yearHigh: String, yearLow: String, dataFields: [[String: String]]) {
        
        self.ask = ask
        self.averageDailyVolume = averageDailyVolume
        self.bid = bid
        self.bookValue = bookValue
        self.changeNumeric = changeNumeric
        self.changePercent = changePercent
        self.dayHigh = dayHigh
        self.dayLow = dayLow
        self.dividendShare = dividendShare
        self.dividendYield = dividendYield
        self.ebitda = ebitda
        self.epsEstimateCurrentYear = epsEstimateCurrentYear
        self.epsEstimateNextQtr = epsEstimateNextQtr
        self.epsEstimateNextYr = epsEstimateNextYr
        self.eps = eps
        self.fiftydayMovingAverage = fiftydayMovingAverage
        self.lastTradeDate = lastTradeDate
        self.last = last
        self.lastTradeTime = lastTradeTime
        self.lastTradePrice = lastTradePrice
        self.marketCap = marketCap
        self.companyName = companyName
        self.oneYearTarget = oneYearTarget
        self.open = open
        self.pegRatio = pegRatio
        self.peRatio = peRatio
        self.previousClose = previousClose
        self.priceBook = priceBook
        self.priceSales = priceSales
        self.shortRatio = shortRatio
        self.stockExchange = stockExchange
        self.symbol = symbol
        self.twoHundreddayMovingAverage = twoHundreddayMovingAverage
        self.volume = volume
        self.yearHigh = yearHigh
        self.yearLow = yearLow
        self.dataFields = dataFields
        
    }

}
