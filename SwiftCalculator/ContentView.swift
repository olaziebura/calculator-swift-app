// Główna zawartość aplikacji, pokazuje wyświetlacz i przyciski

import SwiftUI

struct ContentView: View {
	@State var input: Input = .init()
	
	var body: some View {
		VStack {
			Spacer()
			HStack {
				Spacer()
				DisplayView(input: $input)
			}
			NumberPad(input: $input)
		}
		.padding()
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
