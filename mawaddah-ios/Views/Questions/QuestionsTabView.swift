import SwiftUI

struct QuestionsTabView: View {
  @StateObject private var viewModel = QuestionDeckViewModel()
  @State private var showQuestionPicker = false
  @EnvironmentObject var personStore: PersonStore

  var body: some View {
    VStack {
      SwipeableFlashcardView(viewModel: viewModel)
        .onAppear {
          // Load saved ratings for selected person when view appears
          viewModel.ratings = personStore.getRatingsForSelected()
          viewModel.index = 0
        }
        .onReceive(viewModel.$ratings) { newRatings in
          // Persist ratings to the selected person
          for (qid, rating) in newRatings {
            personStore.setRating(questionID: qid, rating: rating)
          }
        }
        .onChange(of: personStore.selectedPersonID) { _ in
          // Reload ratings when switching persons
          viewModel.ratings = personStore.getRatingsForSelected()
          viewModel.index = 0
        }
      QuestionPickerButton(viewModel: viewModel, showQuestionPicker: $showQuestionPicker)
        .padding(.bottom, 30)
    }
    .background(Color.appBackground.ignoresSafeArea())
  }
}
