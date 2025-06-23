import SwiftUI

struct DisplayView: View {
	@Binding var input: Input

	var body: some View {
		let originalText = input.retrieveOnDisplay()
		let maxLength = 8

		func formattedText(_ text: String) -> String {
			let cleanedText = text.replacingOccurrences(of: ",", with: "")
			
			// Jeśli liczba przekracza maxLength, konwertuje ją do double i używa notacji e
			if cleanedText.count > maxLength, let value = Double(cleanedText.replacingOccurrences(of: ",", with: "")) {
				let formatter = NumberFormatter()
				formatter.numberStyle = .scientific
				formatter.maximumFractionDigits = 2
				formatter.exponentSymbol = "e"
				formatter.decimalSeparator = ","
				return formatter.string(from: NSNumber(value: value)) ?? text
			}
			return text
		}

		let displayedText = formattedText(originalText)

		return Text(displayedText)
			.font(.system(size: 64))
			.lineLimit(1)
			.padding()
			.animation(.easeInOut, value: displayedText)
	}
}
