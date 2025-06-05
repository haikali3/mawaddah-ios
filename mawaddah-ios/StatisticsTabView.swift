import Charts
import SwiftUI

struct MoodData: Identifiable {
  let id = UUID()
  let day: String
  let mood: Double
}

struct StatisticsTabView: View {
  @State private var selectedTimeFrame: TimeFrame = .week

  enum TimeFrame: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
  }

  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        TimeFramePicker(selectedTimeFrame: $selectedTimeFrame)
        MoodTrackingChart()
        CommunicationStats()
        GoalsProgressChart()
      }
      .padding(.vertical)
    }
    .background(Color.appBackground)
  }
}

struct TimeFramePicker: View {
  @Binding var selectedTimeFrame: StatisticsTabView.TimeFrame

  var body: some View {
    Picker("Time Frame", selection: $selectedTimeFrame) {
      ForEach(StatisticsTabView.TimeFrame.allCases, id: \.self) { timeFrame in
        Text(timeFrame.rawValue).tag(timeFrame)
      }
    }
    .pickerStyle(.segmented)
    .padding(.horizontal)
  }
}

struct MoodTrackingChart: View {
  let moodData: [MoodData] = (0..<7).map { day in
    MoodData(day: "Day \(day + 1)", mood: Double.random(in: 1...5))
  }

  var body: some View {
    VStack(alignment: .leading) {
      Text("Mood Tracking")
        .font(.headline)
        .padding(.horizontal)

      Chart(moodData) { data in
        LineMark(
          x: .value("Day", data.day),
          y: .value("Mood", data.mood)
        )
      }
      .frame(height: 200)
      .padding()
    }
    .background(Color.white)
    .cornerRadius(12)
    .shadow(radius: 2)
    .padding(.horizontal)
  }
}

struct CommunicationStats: View {
  var body: some View {
    HStack(spacing: 15) {
      StatCard(
        title: "Messages",
        value: "128",
        icon: "message.fill"
      )

      StatCard(
        title: "Quality Time",
        value: "4.5h",
        icon: "heart.fill"
      )
    }
    .padding(.horizontal)
  }
}

struct GoalsProgressChart: View {
  var body: some View {
    VStack(alignment: .leading) {
      Text("Goals Progress")
        .font(.headline)
        .padding(.horizontal)

      Chart {
        ForEach(["Personal", "Relationship", "Health"], id: \.self) { category in
          BarMark(
            x: .value("Category", category),
            y: .value("Progress", Double.random(in: 0...100))
          )
        }
      }
      .frame(height: 200)
      .padding()
    }
    .background(Color.white)
    .cornerRadius(12)
    .shadow(radius: 2)
    .padding(.horizontal)
  }
}

struct StatCard: View {
  let title: String
  let value: String
  let icon: String

  var body: some View {
    VStack {
      Image(systemName: icon)
        .font(.title2)
        .foregroundColor(.accentColor)

      Text(value)
        .font(.title)
        .bold()

      Text(title)
        .font(.caption)
        .foregroundColor(.gray)
    }
    .frame(maxWidth: .infinity)
    .padding()
    .background(Color.white)
    .cornerRadius(12)
    .shadow(radius: 2)
  }
}

#Preview {
  StatisticsTabView()
}
