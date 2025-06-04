import SwiftUI

struct SearchQuestionsView: View {
  @StateObject private var viewModel = QuestionDeckViewModel()
  @State private var showDeck = false
  @EnvironmentObject var personStore: PersonStore
  @State private var searchText = ""
  @State private var selectedTags = Set<String>()

  // Filtered questions based on search text and selected tags
  private var filteredQuestions: [Question] {
    viewModel.questions.filter { question in
      (searchText.isEmpty || question.text.localizedCaseInsensitiveContains(searchText))
        && (selectedTags.isEmpty || !Set(question.tags).isDisjoint(with: selectedTags))
    }
  }

  // All unique tags
  private var allTags: [String] {
    Array(Set(viewModel.questions.flatMap { $0.tags })).sorted()
  }

  var body: some View {
    NavigationStack {
      VStack {
        // Tag filter UI
        if !allTags.isEmpty {
          ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
              ForEach(allTags, id: \.self) { tag in
                Button(action: {
                  if selectedTags.contains(tag) {
                    selectedTags.remove(tag)
                  } else {
                    selectedTags.insert(tag)
                  }
                }) {
                  Text(tag)
                    .font(.caption)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(
                      selectedTags.contains(tag) ? Color.accentColor : Color.gray.opacity(0.2)
                    )
                    .foregroundColor(selectedTags.contains(tag) ? Color.white : Color.primary)
                    .cornerRadius(16)
                }
              }
            }
            .padding(.vertical, 8)
            .padding(.horizontal)
          }
        }

        List {
          ForEach(filteredQuestions) { question in
            Button {
              if let newIndex = viewModel.questions.firstIndex(where: { $0.id == question.id }) {
                viewModel.index = newIndex
                showDeck = true
              }
            } label: {
              VStack(alignment: .leading) {
                Text("\(question.id). \(question.text)")
                  .foregroundColor(.primary)
                HStack {
                  ForEach(question.tags, id: \.self) { tag in
                    Text(tag)
                      .font(.caption2)
                      .padding(4)
                      .background(Color.gray.opacity(0.2))
                      .cornerRadius(4)
                  }
                }
              }
            }
          }
        }
        .listStyle(.plain)
        .searchable(text: $searchText, prompt: "Search questions")
      }
      .navigationTitle("Search Questions")
      .sheet(isPresented: $showDeck) {
        SwipeableFlashcardView(viewModel: viewModel)
          .onAppear {
            // Load saved ratings for selected person when view appears
            viewModel.ratings = personStore.getRatingsForSelected()
          }
          .onReceive(viewModel.$ratings) { newRatings in
            for (qid, rating) in newRatings {
              personStore.setRating(questionID: qid, rating: rating)
            }
          }
          .onChange(of: personStore.selectedPersonID) { _, _ in
            viewModel.ratings = personStore.getRatingsForSelected()
          }
      }
    }
  }
}

#Preview {
  SearchQuestionsView()
    .environmentObject(PersonStore())
}
