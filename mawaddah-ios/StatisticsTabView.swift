import Charts
import SwiftUI

struct MoodData: Identifiable {
  let id = UUID()
  let day: String
  let mood: Double
}

// TODO: Add a button to delete all data for a specific partner & QA features
struct StatisticsTabView: View {
  @StateObject private var partnerStore = PartnerStore.shared
  @State private var selectedPartnerIndex = 0
  @State private var showDeleteAlert = false

  var body: some View {
    ZStack(alignment: .bottom) {
      StatisticsContent(partnerStore: partnerStore)
      HStack(spacing: 12) {
        PartnerSelectorView(partnerStore: partnerStore, selectedIndex: $selectedPartnerIndex)
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
            Image(systemName: "trash")
              .font(.title2)
              .foregroundColor(.red)
          }
          .frame(height: 50)
        }
      }
      .padding(.horizontal)
      .padding(.bottom, 30)
    }
    .onAppear {
      updateSelectedIndex()
    }
    .onChange(of: selectedPartnerIndex) { oldValue, newIndex in
      if newIndex < partnerStore.partners.count {
        partnerStore.selectPartner(partnerStore.partners[newIndex])
      }
    }
    .onChange(of: partnerStore.selectedPartnerID) { oldValue, newValue in
      updateSelectedIndex()
    }
    .alert("Delete All Data", isPresented: $showDeleteAlert) {
      Button("Cancel", role: .cancel) {}
      Button("Delete", role: .destructive) {
        partnerStore.deleteAllRatingsForSelected()
      }
    } message: {
      Text(
        "Are you sure you want to delete all ratings data for the selected partner? This action cannot be undone."
      )
    }
  }

  private func updateSelectedIndex() {
    if let selectedID = partnerStore.selectedPartnerID,
      let index = partnerStore.partners.firstIndex(where: { $0.id == selectedID })
    {
      selectedPartnerIndex = index
    }
  }
}

private struct StatisticsContent: View {
  @ObservedObject var partnerStore: PartnerStore

  var body: some View {
    ScrollView {
      VStack(spacing: 15) {
        QuestionRatingsChart(partnerStore: partnerStore)
        CommunicationStats(partnerStore: partnerStore)
        GoalsProgressChart(partnerStore: partnerStore)
      }
      .padding(.vertical)
      .padding(.bottom, 60)
    }
    .background(Color.appBackground)
  }
}

// Select partner
private struct PartnerSelectorView: View {
  @ObservedObject var partnerStore: PartnerStore
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
          ForEach(Array(partnerStore.partners.enumerated()), id: \.element.id) { (index, partner) in
            Text(partner.name).tag(index)
          }
        }
        .pickerStyle(.menu)
        .tint(QuestionColors.borderColour)
      }
      .frame(height: 50)
    }
  }
}

private struct QuestionRatingsChart: View {
  @ObservedObject var partnerStore: PartnerStore

  var ratingsData: [MoodData] {
    guard let selectedPartnerID = partnerStore.selectedPartnerID,
      let partnerRatings = partnerStore.ratings[selectedPartnerID]
    else {
      return []
    }

    return partnerRatings.sorted { $0.key < $1.key }.map { questionID, rating in
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

private struct CommunicationStats: View {
  @ObservedObject var partnerStore: PartnerStore

  var stats: (totalQuestions: Int, averageRating: Double) {
    guard let selectedPartnerID = partnerStore.selectedPartnerID,
      let partnerRatings = partnerStore.ratings[selectedPartnerID]
    else {
      return (0, 0)
    }

    let total = partnerRatings.count
    let average = total > 0 ? Double(partnerRatings.values.reduce(0, +)) / Double(total) : 0

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

private struct GoalsProgressChart: View {
  @ObservedObject var partnerStore: PartnerStore

  var tagRatings: [(tag: String, average: Double)] {
    guard let selectedPartnerID = partnerStore.selectedPartnerID,
      let partnerRatings = partnerStore.ratings[selectedPartnerID]
    else {
      return []
    }

    // Get all questions from the repository
    let questions = QuestionRepository.loadAll()

    // Create a dictionary to store tag ratings
    var tagRatingsDict: [String: [Int]] = [:]

    // For each rated question, add its rating to its tags
    for (questionID, rating) in partnerRatings {
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

private struct StatCard: View {
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
