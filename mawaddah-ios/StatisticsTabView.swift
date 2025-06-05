import Charts
import SwiftUI

struct MoodData: Identifiable {
  let id = UUID()
  let day: String
  let mood: Double
}

struct StatisticsTabView: View {
  @State private var selectedTimeFrame: TimeFrame = .week
  @EnvironmentObject var personStore: PersonStore

  enum TimeFrame: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
  }

  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        QuestionRatingsChart()
        CommunicationStats()
        GoalsProgressChart()
      }
      .padding(.vertical)
    }
    .background(Color.appBackground)
  }
}

struct QuestionRatingsChart: View {
  @EnvironmentObject var personStore: PersonStore

  var ratingsData: [MoodData] {
    guard let selectedPersonID = personStore.selectedPersonID,
      let personRatings = personStore.ratings[selectedPersonID]
    else {
      return []
    }

    return personRatings.sorted { $0.key < $1.key }.map { questionID, rating in
      MoodData(day: "Q\(questionID)", mood: Double(rating))
    }
  }

  var body: some View {
    VStack(alignment: .leading) {
      Text("Question Ratings")
        .font(.headline)
        .padding(.horizontal)

      if ratingsData.isEmpty {
        Text("No ratings yet")
          .foregroundColor(.gray)
          .frame(maxWidth: .infinity, alignment: .center)
          .padding()
      } else {
        Chart(ratingsData) { data in
          LineMark(
            x: .value("Question", data.day),
            y: .value("Rating", data.mood)
          )
          .foregroundStyle(Color.purple.gradient)

          PointMark(
            x: .value("Question", data.day),
            y: .value("Rating", data.mood)
          )
          .foregroundStyle(Color.purple)
        }
        .frame(height: 200)
        .padding()
      }
    }
    .background(Color.white)
    .cornerRadius(12)
    .shadow(radius: 2)
    .padding(.horizontal)
  }
}

struct CommunicationStats: View {
  @EnvironmentObject var personStore: PersonStore

  var stats: (totalQuestions: Int, averageRating: Double) {
    guard let selectedPersonID = personStore.selectedPersonID,
      let personRatings = personStore.ratings[selectedPersonID]
    else {
      return (0, 0)
    }

    let total = personRatings.count
    let average = total > 0 ? Double(personRatings.values.reduce(0, +)) / Double(total) : 0

    return (total, average)
  }

  var body: some View {
    HStack(spacing: 15) {
      StatCard(
        title: "Questions Rated",
        value: "\(stats.totalQuestions)",
        icon: "questionmark.circle.fill"
      )

      StatCard(
        title: "Average Rating",
        value: String(format: "%.1f", stats.averageRating),
        icon: "heart.fill"
      )
    }
    .padding(.horizontal)
  }
}

struct GoalsProgressChart: View {
  @EnvironmentObject var personStore: PersonStore

  var tagRatings: [(tag: String, average: Double)] {
    guard let selectedPersonID = personStore.selectedPersonID,
      let personRatings = personStore.ratings[selectedPersonID]
    else {
      return []
    }

    // Get all questions from the repository
    let questions = QuestionRepository.loadAll()

    // Create a dictionary to store tag ratings
    var tagRatingsDict: [String: [Int]] = [:]

    // For each rated question, add its rating to its tags
    for (questionID, rating) in personRatings {
      if let question = questions.first(where: { $0.id == questionID }) {
        for tag in question.tags {
          tagRatingsDict[tag, default: []].append(rating)
        }
      }
    }

    // Calculate averages and sort by average rating
    return tagRatingsDict.map { tag, ratings in
      let average = Double(ratings.reduce(0, +)) / Double(ratings.count)
      return (tag: tag, average: average)
    }.sorted { $0.average > $1.average }
  }

  var body: some View {
    VStack(alignment: .leading) {
      Text("Ratings by Category")
        .font(.headline)
        .padding(.horizontal)

      if tagRatings.isEmpty {
        Text("No ratings yet")
          .foregroundColor(.gray)
          .frame(maxWidth: .infinity, alignment: .center)
          .padding()
      } else {
        Chart {
          ForEach(tagRatings, id: \.tag) { item in
            BarMark(
              x: .value("Category", item.tag),
              y: .value("Rating", item.average)
            )
            .foregroundStyle(Color.purple.gradient)
          }
        }
        .frame(height: 200)
        .padding()
      }
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
