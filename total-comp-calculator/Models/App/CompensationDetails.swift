//
//  CompensationDetails.swift
//  total-comp-calculator
//
//  Created by Brandon Assing on 2024-11-13.
//

import Foundation

struct CompensationDetails {
    let salary: Double
    let rsuTotalValue: Double
    let currency: Currency
}

extension CompensationDetails {
    var totalCompensation: Double {
        salary + rsuTotalValue
    }
    
    var formattedTotalCompensation: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: currency.localeIdentifier)

        guard let formattedTotalCompensation = formatter.string(from: NSNumber(value: totalCompensation)) else {
            return "$\(totalCompensation) \(currency.rawValue)"
        }
        
        return formattedTotalCompensation
    }
}

enum Currency: String {
    case usd = "USD"
    case cad = "CAD"
    
    var localeIdentifier: String {
        switch self {
        case .usd:
            "en_US"
        case .cad:
            "en_CA"
        }
    }
}
