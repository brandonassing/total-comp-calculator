//
//  TextfieldView.swift
//  total-comp-calculator
//
//  Created by Brandon Assing on 2024-11-14.
//

import SwiftUI

struct NumberTextFieldView<V: Numeric>: View {
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    let label: String
    @Binding var value: V?
    
    var body: some View {
        TextField(label, value: $value, formatter: formatter)
            .keyboardType(.decimalPad) // TODO: don't want decimal for Int input
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}
