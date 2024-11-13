//
//  DependencyContainer.swift
//  total-comp-calculator
//
//  Created by Brandon Assing on 2024-11-13.
//

typealias Dependecies = HasCalculatorService

class DependencyContainer {
    static let shared = DependencyContainer()
    private init() {}
}

extension DependencyContainer: Dependecies {
    var calculatorService: CalculatorServicing {
        return CalculatorService()
    }
}
