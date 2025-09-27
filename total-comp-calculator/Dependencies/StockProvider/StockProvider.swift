//
//  StockProvider.swift
//  total-comp-calculator
//
//  Created by Brandon Assing on 2024-11-13.
//

class StockProvider: StockProviding {
    typealias Dependencies = HasStockNetworkService & HasPersistenceService

    private let stockNetworkService: StockNetworkServicing
    private let persistenceService: PersistenceServicing
    
    init(dependencies: Dependencies) {
        self.stockNetworkService = dependencies.stockNetworkService
        self.persistenceService = dependencies.persistenceService
    }

    func getStockQuote(for symbol: String, at timeFrame: StockPriceTimeFrame) async throws -> StockQuote {
        // Check persistence layer first
        if let cachedQuote = try await persistenceService.readValidStockQuote(symbol: symbol, currency: Currency.usd.rawValue) {
            return StockQuote(symbol: cachedQuote.symbol, price: cachedQuote.price, currency: .usd)
        }
        
        // If not in cache, fetch from network
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
            
            // Cache the result for future use
            try await persistenceService.writeStockQuote(symbol: symbol, price: price, currency: Currency.usd.rawValue)
            
            return StockQuote(symbol: symbol, price: price, currency: .usd)
        case .failure(let error):
            throw error
        }
    }
    
    func getStockQuote(for symbol: String, at timeFrame: StockPriceTimeFrame, in currency: Currency) async throws -> StockQuote {
        // Check persistence layer first for the converted quote
        if let cachedQuote = try await persistenceService.readValidStockQuote(symbol: symbol, currency: currency.rawValue) {
            return StockQuote(symbol: cachedQuote.symbol, price: cachedQuote.price, currency: currency)
        }
        
        // Stock quote is returned in USD.
        let stockQuote = try await getStockQuote(for: symbol, at: timeFrame)
        
        // Convert stock quote to specified currency.
        let exchangeRate = try await getUSDExchangeRate(for: currency)
        let convertedPrice = exchangeRate.rate * stockQuote.price
        
        // Cache the converted result for future use
        try await persistenceService.writeStockQuote(symbol: symbol, price: convertedPrice, currency: currency.rawValue)
        
        return StockQuote(symbol: symbol, price: convertedPrice, currency: currency)
    }
    
    func getUSDExchangeRate(for currency: Currency) async throws -> CurrencyExchangeRate {
        // Check persistence layer first
        if let cachedRate = try await persistenceService.readValidCurrencyExchangeRate(fromCurrency: Currency.usd.rawValue, toCurrency: currency.rawValue) {
            return CurrencyExchangeRate(rate: cachedRate.rate)
        }
        
        // If not in cache, fetch from network
        let exchangeRateResult = await stockNetworkService.getExchangeRate(from: Currency.usd.rawValue, to: currency.rawValue)
        switch exchangeRateResult {
        case .success(let result):
            guard let rate = Double(result.exchangeRate) else {
                throw Error.invalidExchangeRate
            }
            
            // Cache the result for future use
            try await persistenceService.writeCurrencyExchangeRate(fromCurrency: Currency.usd.rawValue, toCurrency: currency.rawValue, rate: rate)
            
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
