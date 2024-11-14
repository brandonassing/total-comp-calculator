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
        Text(viewModel.totalCompensationFormatted ?? "Loading...")
            .onAppear {
                viewModel.calculateTapped.send()
            }
    }
}

#Preview {
    CalculatorView()
}
