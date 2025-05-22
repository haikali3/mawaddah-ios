import SwiftUI
import UIKit               // ← make sure you import this
import DDSpiderChart      // v0.5 only has DDSpiderChartView

struct UIKitSpiderChart: UIViewRepresentable {
  // 1) Tell SwiftUI what UIView subclass you’re wrapping:
  typealias UIViewType = DDSpiderChartView

  func makeUIView(context: Context) -> DDSpiderChartView {
    let view = DDSpiderChartView()
    view.axes = ["A1","A2","A3","A4","A5"]
    view.addDataSet(values: [0.8,0.5,0.7,0.9,0.6], color: .red)
    view.addDataSet(values: [0.6,0.9,0.5,0.7,0.8], color: .blue)
    return view
  }

  func updateUIView(_ uiView: DDSpiderChartView, context: Context) {
    // If you ever need to redraw with new data, do it here
  }
}

struct StatisticsTabView: View {
  var body: some View {
    ZStack {
      Color.purple.opacity(0.3).ignoresSafeArea()

      VStack(spacing: 20) {
        Text("Statistics")
          .font(.title)

        UIKitSpiderChart()
          .frame(width: 300, height: 300)
      }
    }
  }
}
