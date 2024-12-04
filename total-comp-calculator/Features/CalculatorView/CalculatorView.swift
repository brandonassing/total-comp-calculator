//
//  CalculatorView.swift
//  total-comp-calculator
//
//  Created by Brandon Assing on 2024-11-13.
//

import SwiftUI

struct CalculatorView: View {
    @StateObject private var viewModel = CalculatorViewModel(dependencies: DependencyContainer.shared)
    

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Salary")
                HStack {
                    NumberTextFieldView(
                        label: "Annual salary",
                        value: $viewModel.salary
                    )
                    
                    DropdownView(
                        labelText: "Currency",
                        items: self.viewModel.currencyOptions,
                        selectAction: { viewModel.currency = $0 },
                        selectPublisher: viewModel.$currency.eraseToAnyPublisher()
                    )
                }
            }
            
            Spacer()
                .frame(height: 15)
            
            VStack(alignment: .leading) {
                Text("RSUs")
                
                NumberTextFieldView(
                    label: "# of RSUs",
                    value: $viewModel.rsuCount
                )

                HStack {
                    switch viewModel.stockInput {
                    case .symbol:
                        TextField("Stock symbol", text: $viewModel.stockSymbol)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    case .price:
                        NumberTextFieldView(
                            label: "Stock price",
                            value: $viewModel.stockPrice
                        )
                    case .none:
                        Text("Select a stock input method.")
                    }
                    
                    DropdownView(
                        labelText: "Stock input",
                        items: self.viewModel.stockInputOptions,
                        selectAction: { viewModel.stockInput = $0 },
                        selectPublisher: viewModel.$stockInput.eraseToAnyPublisher()
                    )
                }
            }
            
            if let totalCompensationFormatted = viewModel.totalCompensationFormatted {
                Text("Total Compensation: \(totalCompensationFormatted)")
            }
            
            Spacer()
            
            PrimaryButtonView(text: "Calculate") {
                viewModel.calculateTapped.send()
            }
        }
        .padding()
    }
}

#Preview {
    CalculatorView()
}
