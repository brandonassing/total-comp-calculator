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
        let stockQuoteResult = await stockNetworkService.getStockQuote(for: symbol)
        switch stockQuoteResult {
        case .success(let result):
            let price: Double? = {
                let priceString: String
                switch timeFrame {
                case .now:
                    priceString = result.price // TODO: add support for live quotes.
                case .yesterdayClose:
                    priceString = result.price
                }
                return Double(priceString)
            }()
            
            guard let price else {
                throw Error.invalidPrice
            }
            
            return StockQuote(symbol: symbol, price: price, currency: .usd)
        case .failure(let error):
            throw error
        }
    }
    
    func getStockQuote(for symbol: String, at timeFrame: StockPriceTimeFrame, in currency: Currency) async throws -> StockQuote {
        let stockQuote = try await getStockQuote(for: symbol, at: timeFrame)
        let exchangeRate = try await getUSDExchangeRate(for: currency)
        let convertedPrice = exchangeRate.rate * stockQuote.price
        return StockQuote(symbol: symbol, price: convertedPrice, currency: currency)
    }
    
    func getUSDExchangeRate(for currency: Currency) async throws -> CurrencyExchangeRate {
        let exchangeRateResult = await stockNetworkService.getExchangeRate(from: Currency.usd.rawValue, to: currency.rawValue)
        switch exchangeRateResult {
        case .success(let result):
            guard let rate = Double(result.exchangeRate) else {
                throw Error.invalidExchangeRate
            }
            return CurrencyExchangeRate(rate: rate)
        case .failure(let error):
            throw error
        }
    }
    
    enum Error: Swift.Error {
        case invalidPrice
        case invalidExchangeRate
    }
}
