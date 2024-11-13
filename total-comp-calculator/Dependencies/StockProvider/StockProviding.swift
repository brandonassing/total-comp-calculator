//
//  StockProviding.swift
//  total-comp-calculator
//
//  Created by Brandon Assing on 2024-11-13.
//

protocol HasStockProvider {
    var stockProvider: StockProviding { get }
}

protocol StockProviding {
    func getStockPrice(for symbol: String, at timeFrame: StockPriceTimeFrame) async throws -> StockQuote
}

enum StockPriceTimeFrame {
    case now
    case yesterdayClose
}
