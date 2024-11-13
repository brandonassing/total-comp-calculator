//
//  DependencyContainer.swift
//  total-comp-calculator
//
//  Created by Brandon Assing on 2024-11-13.
//

typealias Dependecies = HasCalculatorService & HasStockNetworkService

class DependencyContainer: Dependecies {
    static let shared = DependencyContainer()
    private init() {}
    
    lazy var calculatorService: CalculatorServicing = {
        return CalculatorService()
    }()
    
    lazy var stockNetworkService: StockNetworkServicing = {
        return StockNetworkService()
    }()
}
