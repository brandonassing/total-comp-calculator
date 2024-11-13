//
//  CalculatorService.swift
//  total-comp-calculator
//
//  Created by Brandon Assing on 2024-11-13.
//

class CalculatorService: CalculatorServicing {
    typealias Dependencies = HasStockProvider

    private let stockProvider: StockProviding

    init(dependencies: Dependencies) {
        self.stockProvider = dependencies.stockProvider
    }
}
