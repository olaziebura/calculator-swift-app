import SwiftUI

struct ClearButton: View {
    @Binding var input: Input
	
    var body: some View {
        Button(action: {
			self.input.clearOnDisplay()
			withAnimation { self.input.resetInput() }
		}) {
			Text(input.clear ? "AC" : "C")
				.font(.title)
				.modifier(SpecialButtonTextModifier())
		}
		.modifier(CalculatorButtonViewModifier())
    }
}

struct ChangeSignButton: View {
    @Binding var input: Input
	
    var body: some View {
        Button(action: {
			self.input.changeSignButtonPressed()
		}) {
			Text("+/-")
				.font(.title)
				.modifier(SpecialButtonTextModifier())
		}
		.modifier(CalculatorButtonViewModifier())
    }
}

struct PercentButton: View {
    @Binding var input: Input
	
    var body: some View {
        Button(action: {
			self.input.percentButtonPressed()
		}) {
			Text("%")
				.font(.title)
				.modifier(SpecialButtonTextModifier())
		}
		.modifier(CalculatorButtonViewModifier())
    }
}
