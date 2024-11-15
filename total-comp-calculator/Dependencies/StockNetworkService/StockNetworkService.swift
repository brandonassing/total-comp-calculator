//
//  StockNetworkService.swift
//  total-comp-calculator
//
//  Created by Brandon Assing on 2024-11-13.
//

import Foundation

class StockNetworkService: StockNetworkServicing {
    private static let baseURL = "https://www.alphavantage.co/query"
    private var apiKey: String? {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
           let config = NSDictionary(contentsOfFile: path) as? [String: Any],
           let apiKey = config["ALPHA_VANTAGE_API_KEY"] as? String
        else {
            return nil
        }
        return apiKey
    }

    private var requestSender: RequestSender {
        RequestSender(apiKey: apiKey, baseURL: StockNetworkService.baseURL)
    }

    init() {}
    
    func getStockQuote(for symbol: String) async -> Result<StockQuoteAPI, any Error> {
        let queryParams = [
            "function": "GLOBAL_QUOTE",
            "symbol": symbol,
        ]
        
        let responseResult = await requestSender.makeRequest(with: queryParams)
        switch responseResult {
        case .success(let data):
            guard let result = try? JSONDecoder().decode(StockQuoteResponse.self, from: data) else {
                return .failure(RequestSender.NetworkError.decodingFailed)
            }

            return .success(result.globalQuote)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getExchangeRate(from currency1: String, to currency2: String) async -> Result<CurrencyExchangeRateAPI, any Error> {
        let queryParams = [
            "function": "CURRENCY_EXCHANGE_RATE",
            "from_currency": currency1,
            "to_currency": currency2,
        ]
        let responseResult = await requestSender.makeRequest(with: queryParams)
        switch responseResult {
        case .success(let data):
            guard let result = try? JSONDecoder().decode(CurrencyExchangeRateAPI.self, from: data) else {
                return .failure(RequestSender.NetworkError.decodingFailed)
            }
            return .success(result)
        case .failure(let error):
            return .failure(error)
        }
    }
}
