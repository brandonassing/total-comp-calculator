//
//  PersistedCurrencyExchangeRate.swift
//  total-comp-calculator
//
//  Created by Brandon Assing on 2024-11-13.
//

import Foundation
import SwiftData

@Model
final class PersistedCurrencyExchangeRate {
    let fromCurrency: String
    let toCurrency: String
    let rate: Double
    let timestamp: Date
    let expirationDate: Date
    
    init(fromCurrency: String, toCurrency: String, rate: Double, timestamp: Date = Date(), expirationDate: Date) {
        self.fromCurrency = fromCurrency
        self.toCurrency = toCurrency
        self.rate = rate
        self.timestamp = timestamp
        self.expirationDate = expirationDate
    }
    
    var isExpired: Bool {
        Date() > expirationDate
    }
}
