//
//  CalculatorServicing.swift
//  total-comp-calculator
//
//  Created by Brandon Assing on 2024-11-13.
//

import Combine

protocol HasCalculatorService {
    var calculatorService: CalculatorServicing { get }
}

protocol CalculatorServicing {
    /// Returns total compensation in the specified `currency`, calculated using the current stock price.
    func getTotalCompensation(in currency: Currency, salary: Double, rsuCount: Int, stockSymbol: String) -> AnyPublisher<Result<CompensationDetails, Error>, Never>
    
    /// Returns total compensation in the specified `currency`, calculated using the specified stock price.
    /// `stockPrice`should be in USD.
    func getTotalCompensation(in currency: Currency, salary: Double, rsuCount: Int, stockPrice: Double) -> AnyPublisher<Result<CompensationDetails, Error>, Never>
}
