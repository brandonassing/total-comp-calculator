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

    func getStockPrice(for symbol: String, at timeFrame: StockPriceTimeFrame) async throws -> StockQuote {
        return StockQuote(symbol: "SQ", price: 82.50)
    }
}
