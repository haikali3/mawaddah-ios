import Charts
import SwiftUI

struct MoodData: Identifiable {
  let id = UUID()
  let day: String
  let mood: Double
}

struct StatisticsTabView: View {
  @EnvironmentObject var personStore: PersonStore
  @State private var selectedPartnerIndex = 0
  @State private var showDeleteAlert = false

  var body: some View {
    ZStack(alignment: .bottom) {
      StatisticsContent()
      HStack(spacing: 12) {
        PartnerSelectorView(selectedIndex: $selectedPartnerIndex)
          .frame(maxWidth: .infinity)

        Button {
          showDeleteAlert = true
        } label: {
          ZStack {
            RoundedRectangle(cornerRadius: 30)
              .fill(QuestionColors.cardColour)
              .overlay(
                RoundedRectangle(cornerRadius: 30)
                  .stroke(QuestionColors.borderColour, lineWidth: 2)
              )
            Text("Delete All Data")
              .font(.headline)
              .foregroundColor(.red)
          }
          .frame(height: 50)
        }
      }
      .padding(.horizontal)
      .padding(.bottom, 30)
    }
    .onChange(of: selectedPartnerIndex) { oldValue, newIndex in
      if newIndex < personStore.persons.count {
        personStore.selectedPersonID = personStore.persons[newIndex].id
      }
    }
    .alert("Delete All Data", isPresented: $showDeleteAlert) {
      Button("Cancel", role: .cancel) {}
      Button("Delete", role: .destructive) {
        if let selectedID = personStore.selectedPersonID {
          personStore.ratings[selectedID] = [:]
        }
      }
    } message: {
      Text(
        "Are you sure you want to delete all ratings data for the selected partner? This action cannot be undone."
      )
    }
  }
}

private struct StatisticsContent: View {
  @EnvironmentObject var personStore: PersonStore

  var body: some View {
    ScrollView {
      VStack(spacing: 15) {
        QuestionRatingsChart()
        CommunicationStats()
        GoalsProgressChart()
      }
      .padding(.vertical)
      .padding(.bottom, 60)
    }
    .background(Color.appBackground)
  }
}

// Select partner
private struct PartnerSelectorView: View {
  @EnvironmentObject var personStore: PersonStore
  @Binding var selectedIndex: Int

  var body: some View {
    Button {
      // No action needed as Picker handles selection
    } label: {
      ZStack {
        RoundedRectangle(cornerRadius: 30)
          .fill(QuestionColors.cardColour)
          .overlay(
            RoundedRectangle(cornerRadius: 30)
              .stroke(QuestionColors.borderColour, lineWidth: 2)
          )
        Picker("Select Partner", selection: $selectedIndex) {
          ForEach(Array(personStore.persons.enumerated()), id: \.element.id) { index, person in
            Text(person.name).tag(index)
          }
        }
        .pickerStyle(.menu)
        .tint(QuestionColors.borderColour)
      }
      .frame(height: 50)
    }
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
        .padding()

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
          .foregroundStyle(QuestionColors.borderColour.gradient)

          PointMark(
            x: .value("Question", data.day),
            y: .value("Rating", data.mood)
          )
          .foregroundStyle(QuestionColors.borderColour)
        }
        .frame(height: 180)
        .padding()
      }
    }
    .background(QuestionColors.cardColour)
    .cornerRadius(30)
    .overlay(
      RoundedRectangle(cornerRadius: 30)
        .stroke(QuestionColors.borderColour, lineWidth: 2)
    )
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
    HStack(spacing: 12) {
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
        .padding()

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
            .foregroundStyle(QuestionColors.borderColour.gradient)
          }
        }
        .frame(height: 150)
        .padding(.horizontal)
        .padding(.bottom, 8)
      }
    }
    .background(QuestionColors.cardColour)
    .cornerRadius(30)
    .overlay(
      RoundedRectangle(cornerRadius: 30)
        .stroke(QuestionColors.borderColour, lineWidth: 2)
    )
    .padding(.horizontal)
  }
}

struct StatCard: View {
  let title: String
  let value: String
  let icon: String

  var body: some View {
    VStack(spacing: 4) {
      Image(systemName: icon)
        .font(.title3)
        .foregroundColor(QuestionColors.borderColour)

      Text(value)
        .font(.title2)
        .bold()

      Text(title)
        .font(.caption)
        .foregroundColor(.gray)
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 12)
    .background(QuestionColors.cardColour)
    .cornerRadius(30)
    .overlay(
      RoundedRectangle(cornerRadius: 30)
        .stroke(QuestionColors.borderColour, lineWidth: 2)
    )
  }
}

#Preview {
  StatisticsTabView()
}
