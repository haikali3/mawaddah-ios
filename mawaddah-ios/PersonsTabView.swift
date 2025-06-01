import SwiftUI

struct PersonsTabView: View {
  var body: some View {
    ZStack {
      Color.purple.opacity(0.3).ignoresSafeArea()
      Text("Persons")
        .font(.title)
        .foregroundColor(.black)
    }
  }
}
