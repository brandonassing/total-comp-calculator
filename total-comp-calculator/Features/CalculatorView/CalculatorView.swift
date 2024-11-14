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
            HStack {
                NumberTextFieldView(
                    label: "Salary",
                    value: $viewModel.salary
                )
                
                DropdownView(
                    labelText: "Currency",
                    items: self.viewModel.currencyOptions,
                    selectAction: { viewModel.currency = $0 },
                    selectPublisher: viewModel.$currency.eraseToAnyPublisher()
                )
            }
            
            Spacer()
                .frame(height: 10)
            
            HStack {
                NumberTextFieldView(
                    label: "# of RSUs",
                    value: $viewModel.rsuCount
                )
                
                TextField("Stock symbol", text: $viewModel.stockSymbol)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            if let totalCompensationFormatted = viewModel.totalCompensationFormatted {
                Text("Total Compensation: \(totalCompensationFormatted)")
            }
            
            Spacer()
            
            PrimaryButtonView(text: "Calculate") {
                viewModel.calculateTapped.send()
            }
        }
    }
}

#Preview {
    CalculatorView()
}
