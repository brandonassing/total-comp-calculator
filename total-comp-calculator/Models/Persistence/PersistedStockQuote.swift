//
//  PersistedStockQuote.swift
//  total-comp-calculator
//
//  Created by Brandon Assing on 2024-11-13.
//

import Foundation
import SwiftData

@Model
final class PersistedStockQuote {
    let symbol: String
    let price: Double
    let currency: String
    let timestamp: Date
    let expirationDate: Date
    
    init(symbol: String, price: Double, currency: String, timestamp: Date = Date(), expirationDate: Date) {
        self.symbol = symbol
        self.price = price
        self.currency = currency
        self.timestamp = timestamp
        self.expirationDate = expirationDate
    }
    
    var isExpired: Bool {
        Date() > expirationDate
    }
}
