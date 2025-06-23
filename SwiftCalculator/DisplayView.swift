import SwiftUI

struct DisplayView: View {
	@Binding var input: Input
	
    var body: some View {
		Text(input.retrieveOnDisplay())
			.frame(alignment: .bottomTrailing)
			.font(.system(size: 78))
			.minimumScaleFactor(0.0005)
			.lineLimit(1)
			.padding()
    }
}
