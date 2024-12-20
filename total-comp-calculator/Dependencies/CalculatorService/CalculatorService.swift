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
    
    func getTotalCompensation(in currency: Currency, salary: Double, rsuCount: Int, stockSymbol: String) -> AnyPublisher<Result<CompensationDetails, Error>, Never> {
        Future { [weak self] promise in
            guard let self else {
                promise(.success(.failure(CalculatorError.unknownError)))
                return
            }
            Task {
                do {
                    let stockQuote = try await self.stockProvider.getStockQuote(for: stockSymbol, at: .yesterdayClose, in: currency)
                    // Stock quote is in the specified currency.
                    let totalStockValue = Double(rsuCount) * stockQuote.price
                    let compensationDetails = CompensationDetails(salary: salary, rsuTotalValue: totalStockValue, currency: currency)
                    promise(.success(.success(compensationDetails)))
                } catch {
                    promise(.success(.failure(CalculatorError.stockPriceNotFound(underlyingError: error))))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func getTotalCompensation(in currency: Currency, salary: Double, rsuCount: Int, stockPrice: Double) -> AnyPublisher<Result<CompensationDetails, Error>, Never> {
        Future { [weak self] promise in
            guard let self else {
                promise(.success(.failure(CalculatorError.unknownError)))
                return
            }
            Task {
                do {
                    // Total stock value is in USD.
                    let totalStockValue = Double(rsuCount) * stockPrice
                    
                    // Convert stock value to specified currency.
                    let exchangeRate = try await self.stockProvider.getUSDExchangeRate(for: currency)
                    let convertedTotalStockValue = exchangeRate.rate * totalStockValue
                    let compensationDetails = CompensationDetails(salary: salary, rsuTotalValue: convertedTotalStockValue, currency: currency)
                    promise(.success(.success(compensationDetails)))
                } catch {
                    promise(.success(.failure(CalculatorError.stockPriceNotFound(underlyingError: error))))
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
