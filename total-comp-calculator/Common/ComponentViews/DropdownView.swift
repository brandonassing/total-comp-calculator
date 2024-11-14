
import SwiftUI
import Combine

struct DropdownView<T>: View where T: Displayable {
	
	let labelText: String
	var noSelectionText: String? = nil
	var noSelectionAction: (() -> Void)? = nil
	var items: [T]
	var selectAction: (T) -> Void
	var selectPublisher: AnyPublisher<T?, Never>
	
	@State private var selectedItem: T?
	
    var body: some View {
		HStack {
			Text(self.labelText)
			
			Spacer()
			
			Menu {
				if let anySelectedText = self.noSelectionText, let anySelectedAction = self.noSelectionAction {
					Button(anySelectedText, action: anySelectedAction)
				}
				
				ForEach(self.items, id: \.displayName) { item in
					Button(action: { self.selectAction(item) }) {
						Text(item.displayName)
					}
				}
			} label: {
				HStack {
					Text(self.selectedItem?.displayName ?? self.noSelectionText ?? "Select option")
					Image(systemName: "arrowtriangle.down.circle")
				}
			}
			.onReceive(self.selectPublisher, perform: { item in
				self.selectedItem = item
			})

		}
		.padding()
		.background(Color.white)
    }
}
