//
//  DependencyContainer.swift
//  total-comp-calculator
//
//  Created by Brandon Assing on 2024-11-13.
//

typealias AllDependecies = HasCalculatorService & HasStockNetworkService & HasStockProvider

class DependencyContainer: AllDependecies {

    static let shared = DependencyContainer()
    private init() {}
    
    lazy var calculatorService: CalculatorServicing = {
        CalculatorService()
    }()
    
    lazy var stockNetworkService: StockNetworkServicing = {
        StockNetworkService()
    }()
    
    lazy var stockProvider: StockProviding = {
        StockProvider(dependencies: DependencyContainer.shared)
    }()
}
