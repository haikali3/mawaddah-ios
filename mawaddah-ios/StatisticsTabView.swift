import SwiftUI

struct StatisticsTabView: View {
  var body: some View {
    ZStack {
      Color.appBackground.ignoresSafeArea()
      Text("Statistics")
        .font(.title)
        .foregroundColor(.black)
    }
  }
}
