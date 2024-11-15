//
//  StockNetworkServicing.swift
//  total-comp-calculator
//
//  Created by Brandon Assing on 2024-11-13.
//

protocol HasStockNetworkService {
    var stockNetworkService: StockNetworkServicing { get }
}

protocol StockNetworkServicing {
    func getStockQuote(for symbol: String) async -> Result<StockQuoteAPI, Error>
    func getExchangeRate(from currency1: String, to currency2: String) async -> Result<CurrencyExchangeRateAPI, Error>
}
