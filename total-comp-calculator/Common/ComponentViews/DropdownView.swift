
import SwiftUI
import Combine

// TODO: support a default val and make selection non-optional
struct DropdownView<T>: View where T: Displayable {
	
	let labelText: String
	let noSelectionText: String? = nil
	let noSelectionAction: (() -> Void)? = nil
	let items: [T]
	let selectAction: (T) -> Void
	let selectPublisher: AnyPublisher<T?, Never>
    let addSpaceBetween: Bool = false
	
	@State private var selectedItem: T?
	
    var body: some View {
		HStack {
			Text(self.labelText)
			
            if addSpaceBetween {
                Spacer()
            }
            
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
    }
}
