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
    func getStockQuote(for symbol: String, at timeFrame: StockPriceTimeFrame) async throws -> StockQuote
    func getStockQuote(for symbol: String, at timeFrame: StockPriceTimeFrame, in currency: Currency) async throws -> StockQuote
    func getUSDExchangeRate(for currency: Currency) async throws -> CurrencyExchangeRate
}

enum StockPriceTimeFrame {
    case now
    case yesterdayClose
}
