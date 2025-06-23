import SwiftUI

struct OperationButton: View {
	var operation: String
	@Binding var input: Input
	
    var body: some View {
        Button(action: {
			self.input.operationButtonPressed(operation: self.operation)
			withAnimation { self.input.updateSelectedOperation(operation: self.operation) }
		}) {
			Text(self.operation)
				.modifier(OperationButtonTextModifier())
				.foregroundColor(self.input.selectedOperation != operation ? Color.white : Color(.systemBlue))
				.background(self.input.selectedOperation != operation ? Color(.systemBlue) : Color.black)
				.clipShape(Circle())
		}
		.modifier(CalculatorButtonViewModifier())
    }
}
