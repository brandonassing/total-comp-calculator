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
    @Published var salary: Double = 167280
    @Published var rsuCount: Int = 1137
    @Published var currency: Currency = .cad
    @Published var stockSymbol: String = ""
    
    // Outputs
    @Published var totalCompensationFormatted: String?
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(dependencies: Dependencies) {
        calculateTapped
            .flatMap { [weak self] _ -> AnyPublisher<Result<CompensationDetails, Error>, Never> in
                guard let self else { return Empty().eraseToAnyPublisher() }
                return dependencies.calculatorService.getTotalCompensation(in: self.currency, salary: self.salary, rsuCount: self.rsuCount, stockSymbol: self.stockSymbol)
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
