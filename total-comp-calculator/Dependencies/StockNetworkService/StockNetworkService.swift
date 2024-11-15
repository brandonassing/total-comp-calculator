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

    init() {}
    
    private func getURL(with queryParams: [String: String], apiKey: String) -> URL? {
        let queryParams = queryParams.merging(["apikey": apiKey]) { current, new in new }
        
        var urlComponents = URLComponents(string: StockNetworkService.baseURL)
        urlComponents?.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }

        return urlComponents?.url
    }
    
    private func makeRequest(with queryParams: [String: String]) async -> Result<Data, Error> {
        guard let apiKey = apiKey else {
            return .failure(NetworkError.invalidAPIKey)
        }
        guard let url = getURL(with: queryParams, apiKey: apiKey) else {
            return .failure(NetworkError.invalidURL)
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(NetworkError.noResponse)
            }
            guard httpResponse.statusCode == 200 else {
                return .failure(NetworkError.badResponse(httpResponse.statusCode))
            }

            #if DEBUG
            if let responseString = String(data: data, encoding: .utf8) {
                print(responseString)
            }
            #endif
            
            return .success(data)
        } catch {
            return .failure(NetworkError.unknown(error))
        }
    }
    
    func getStockQuote(for symbol: String) async -> Result<StockQuoteAPI, any Error> {
        let queryParams = [
            "function": "GLOBAL_QUOTE",
            "symbol": symbol,
        ]
        
        let responseResult = await makeRequest(with: queryParams)
        switch responseResult {
        case .success(let data):
            guard let result = try? JSONDecoder().decode(StockQuoteResponse.self, from: data) else {
                return .failure(NetworkError.decodingFailed)
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
        let responseResult = await makeRequest(with: queryParams)
        switch responseResult {
        case .success(let data):
            guard let result = try? JSONDecoder().decode(CurrencyExchangeRateAPI.self, from: data) else {
                return .failure(NetworkError.decodingFailed)
            }
            return .success(result)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    enum NetworkError: Error {
        case invalidAPIKey
        case invalidURL
        case noResponse
        case badResponse(_ statusCode: Int)
        case decodingFailed
        case unknown(Error)
    }
}
