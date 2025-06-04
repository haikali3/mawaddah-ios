import SwiftUI

/// Drives the state for the swipeable flash-card deck.
@MainActor
final class QuestionDeckViewModel: ObservableObject {

  // MARK: - Published properties
  @Published var index: Int = 0  // current question index
  @Published var ratings: [Int: Int] = [:]  // questionID → rating (1…5)

  // MARK: - Data source
  let questions: [Question]

  init(questions: [Question] = QuestionRepository.loadAll()) {
    self.questions = questions
  }

  // MARK: - Computed helpers
  var currentQuestion: Question? {
    guard index >= 0 && index < questions.count else { return nil }
    return questions[index]
  }

  /// Safely returns the next question, or nil if at the end.
  var nextQuestion: Question? {
    let next = index + 1
    return next < questions.count ? questions[next] : nil
  }

  // MARK: - Intents
  /// Updates the rating for the supplied question.
  func setRating(_ value: Int, for question: Question) {
    ratings[question.id] = value
  }

  /// Moves to the next card if possible.
  func showNextCard() {
    guard index < questions.count - 1 else { return }
    index += 1
  }

  /// Moves to the previous card if possible.
  func showPreviousCard() {
    guard index > 0 else { return }
    index -= 1
  }

  /// Selects a random question and updates the index.
  func showRandomCard() {
    guard !questions.isEmpty else { return }
    var newIndex: Int
    repeat {
      newIndex = Int.random(in: 0..<questions.count)
    } while questions.count > 1 && newIndex == index
    index = newIndex
  }
}
