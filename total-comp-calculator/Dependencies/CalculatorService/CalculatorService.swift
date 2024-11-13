//
//  CalculatorService.swift
//  total-comp-calculator
//
//  Created by Brandon Assing on 2024-11-13.
//

import Combine

class CalculatorService: CalculatorServicing {
    typealias Dependencies = HasStockProvider

    private let stockProvider: StockProviding

    init(dependencies: Dependencies) {
        self.stockProvider = dependencies.stockProvider
    }
    
    func getTotalCompensation(in currency: Currency, salary: Double, rsuCount: Int, stockSymbol: String) -> AnyPublisher<CompensationDetails, Error> {
        Future { [weak self] promise in
            guard let self else {
                promise(.failure(CalculatorError.unknownError))
                return
            }
            Task {
                do {
                    let stockQuote = try await self.stockProvider.getStockPrice(for: stockSymbol, at: .yesterdayClose)
                    // This will be in USD
                    let totalStockValue = Double(rsuCount) * stockQuote.price
                    
                    let compensationDetails = CompensationDetails(salary: salary, rsuTotalValue: totalStockValue, currency: currency)
                    promise(.success(compensationDetails))
                } catch {
                    promise(.failure(CalculatorError.stockPriceNotFound(underlyingError: error)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

enum CalculatorError: Error {
    case unknownError
    case stockPriceNotFound(underlyingError: Error)
}
