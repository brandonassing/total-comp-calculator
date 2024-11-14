
import SwiftUI

struct PrimaryButtonView: View {
	var text: String?
	var action: (() -> Void)
	
    var body: some View {
		Button(action: self.action) {
			if let text = self.text {
				Text(text)
					.padding()
					.frame(maxWidth: .infinity)
			}
		}
		.cornerRadius(8)
	}
}
