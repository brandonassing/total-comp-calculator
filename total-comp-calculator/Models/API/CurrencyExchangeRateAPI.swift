//
//  CurrencyExchangeRateAPI.swift
//  total-comp-calculator
//
//  Created by Brandon Assing on 2024-11-13.
//

import Foundation
struct CurrencyExchangeRateAPI: Decodable {
    let fromCurrencyCode: String
    let fromCurrencyName: String
    let toCurrencyCode: String
    let toCurrencyName: String
    let exchangeRate: String
    let lastRefreshed: String
    let timeZone: String
    let bidPrice: String
    let askPrice: String

    enum CodingKeys: String, CodingKey {
        case realtimeCurrencyExchangeRate = "Realtime Currency Exchange Rate"
        case fromCurrencyCode = "1. From_Currency Code"
        case fromCurrencyName = "2. From_Currency Name"
        case toCurrencyCode = "3. To_Currency Code"
        case toCurrencyName = "4. To_Currency Name"
        case exchangeRate = "5. Exchange Rate"
        case lastRefreshed = "6. Last Refreshed"
        case timeZone = "7. Time Zone"
        case bidPrice = "8. Bid Price"
        case askPrice = "9. Ask Price"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let exchangeRateContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .realtimeCurrencyExchangeRate)
        fromCurrencyCode = try exchangeRateContainer.decode(String.self, forKey: .fromCurrencyCode)
        fromCurrencyName = try exchangeRateContainer.decode(String.self, forKey: .fromCurrencyName)
        toCurrencyCode = try exchangeRateContainer.decode(String.self, forKey: .toCurrencyCode)
        toCurrencyName = try exchangeRateContainer.decode(String.self, forKey: .toCurrencyName)
        exchangeRate = try exchangeRateContainer.decode(String.self, forKey: .exchangeRate)
        lastRefreshed = try exchangeRateContainer.decode(String.self, forKey: .lastRefreshed)
        timeZone = try exchangeRateContainer.decode(String.self, forKey: .timeZone)
        bidPrice = try exchangeRateContainer.decode(String.self, forKey: .bidPrice)
        askPrice = try exchangeRateContainer.decode(String.self, forKey: .askPrice)
    }
}
