//
//  CalculatorViewModel.swift
//  total-comp-calculator
//
//  Created by Brandon Assing on 2024-11-13.
//

import Combine
import Foundation

class CalculatorViewModel: ObservableObject {
    typealias Dependencies = HasCalculatorService
    
    // Inputs
    let calculateTapped = PassthroughSubject<Void, Never>()
    @Published var salary: Double? = 167280
    @Published var rsuCount: Int? = 1137
    @Published var currency: Currency? = .cad
    @Published var currencyOptions: [Currency] = Currency.allCases
    @Published var stockInput: StockInput? = .symbol
    @Published var stockInputOptions: [StockInput] = StockInput.allCases
    @Published var stockSymbol: String = "SQ"
    @Published var stockPrice: Double? = 75

    // Outputs
    @Published var totalCompensationFormatted: String?
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(dependencies: Dependencies) {
        calculateTapped
            .flatMap { [weak self] _ -> AnyPublisher<Result<CompensationDetails, Error>, Never> in
                guard let self else { return Empty().eraseToAnyPublisher() }
                guard let currency, let salary, let rsuCount, let stockInput else { return Empty().eraseToAnyPublisher() }
                switch stockInput {
                case .symbol:
                    guard !self.stockSymbol.isEmpty else { return Empty().eraseToAnyPublisher() }
                    return dependencies.calculatorService.getTotalCompensation(in: currency, salary: salary, rsuCount: rsuCount, stockSymbol: self.stockSymbol.trimmingCharacters(in: .whitespacesAndNewlines))
                case .price:
                    guard let stockPrice else { return Empty().eraseToAnyPublisher() }
                    return dependencies.calculatorService.getTotalCompensation(in: currency, salary: salary, rsuCount: rsuCount, stockPrice: stockPrice)
                }
            }
            .receive(on: RunLoop.main)
            .sink { result in
                switch result {
                case .success(let compensationDetails):
                    self.totalCompensationFormatted = compensationDetails.formattedTotalCompensation
                case .failure(let error):
                    self.totalCompensationFormatted = nil
                }
            }
            .store(in: &cancellables)
    }
}

enum StockInput: CaseIterable, Displayable {
    case symbol
    case price
    
    var displayName: String {
        switch self {
        case .symbol:
            "Symbol"
        case .price:
            "Price"
        }
    }
}
