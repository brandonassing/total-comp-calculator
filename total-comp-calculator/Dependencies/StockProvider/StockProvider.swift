//
//  StockProvider.swift
//  total-comp-calculator
//
//  Created by Brandon Assing on 2024-11-13.
//

class StockProvider: StockProviding {
    typealias Dependencies = HasStockNetworkService

    private let stockNetworkService: StockNetworkServicing
    
    init(dependencies: Dependencies) {
        self.stockNetworkService = dependencies.stockNetworkService
    }

    func getStockQuote(for symbol: String, at timeFrame: StockPriceTimeFrame) async throws -> StockQuote {
        return StockQuote(symbol: "SQ", price: 82.50)
    }
    
    func getStockQuote(for symbol: String, at timeFrame: StockPriceTimeFrame, in currency: Currency) async throws -> StockQuote {
        let stockQuote = try await getStockQuote(for: symbol, at: timeFrame)
        let convertedPrice = CurrencyExchangeRate(exchangeRate: 1.4).exchangeRate * stockQuote.price
        return StockQuote(symbol: symbol, price: convertedPrice)
    }
}
