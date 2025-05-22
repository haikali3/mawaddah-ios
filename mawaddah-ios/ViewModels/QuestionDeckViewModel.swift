import SwiftUI

/// Drives the state for the swipeable flash-card deck.
@MainActor
final class QuestionDeckViewModel: ObservableObject {

    // MARK: - Published properties
    @Published var index: Int = 0                       // Current question index
    @Published var ratings: [Int: Int] = [:]            // questionID → rating (1…5)

    // MARK: - Data source
    let questions: [Question]

    init(questions: [Question] = QuestionRepository.loadAll()) {
        self.questions = questions
    }

    // MARK: - Computed helpers
    var currentQuestion: Question { questions[index] }

    // MARK: - Intents
    /// Updates the rating for the supplied question.
    func setRating(_ value: Int, for question: Question) {
        ratings[question.id] = value
    }

    /// Advances to the next card if possible.
    func showNextCard() {
        guard index < questions.count - 1 else { return }
        index += 1
    }
} 