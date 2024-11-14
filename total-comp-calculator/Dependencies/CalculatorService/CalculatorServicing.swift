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
    func getTotalCompensation(in currency: Currency, salary: Double, rsuCount: Int, stockSymbol: String) -> AnyPublisher<Result<CompensationDetails, Error>, Never>
}
