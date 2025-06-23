import SwiftUI

struct EqualSignButton: View {
	@Binding var input: Input
	
    var body: some View {
        Button(action: {
			self.input.equalSignButtonPressed()
			withAnimation { self.input.updateSelectedOperation(operation: "=") }
		}) {
			Text("=")
				.modifier(EqualButtonTextModifier())
		}
		.modifier(CalculatorButtonViewModifier())
    }
}
