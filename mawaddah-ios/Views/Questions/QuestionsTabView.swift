import SwiftUI

struct QuestionsTabView: View {
  let questions: [Question] = QuestionRepository.loadAll()
  @State private var currentIndex: Int = 0
  @State private var ratings: [Int: Int] = [:]
  @State private var showQuestionPicker = false
  @StateObject private var partnerStore = PartnerStore.shared

  var currentQuestion: Question? {
    guard currentIndex >= 0 && currentIndex < questions.count else { return nil }
    return questions[currentIndex]
  }

  var body: some View {
    VStack {
      SwipeableFlashcardView(
        questions: questions,
        currentIndex: $currentIndex,
        ratings: $ratings,
        onRatingChanged: { questionID, rating in
          partnerStore.setRating(questionID: questionID, rating: rating)
        }
      )
      .onAppear {
        loadRatings()
      }
      .onChange(of: partnerStore.selectedPartnerID) { oldValue, newValue in
        loadRatings()
      }

      QuestionPickerButton(
        questions: questions,
        currentIndex: $currentIndex,
        showQuestionPicker: $showQuestionPicker
      )
      .padding(.bottom, 30)
    }
    .background(Color.appBackground.ignoresSafeArea())
  }

  private func loadRatings() {
    ratings = partnerStore.getRatingsForSelected()
  }
}
