import Foundation

@MainActor
final class AIAnalysisViewModel: ObservableObject {
    @Published var analysis: String = ""
    @Published var isLoading: Bool = false

    private let personStore: PersonStore
    private let questions: [Question]

    init(personStore: PersonStore, questions: [Question]) {
        self.personStore = personStore
        self.questions = questions
    }

    func generateAnalysis() {
        isLoading = true
        analysis = ""

        // Simulate a network request
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.analysis = self.createSummary()
            self.isLoading = false
        }
    }

    private func createSummary() -> String {
        guard let personID = personStore.selectedPersonID,
            let person = personStore.persons.first(where: { $0.id == personID })
        else {
            return "Please select a partner first."
        }

        let ratings = personStore.getRatingsForSelected()

        if ratings.isEmpty {
            return "No analysis available. Please answer some questions for \(person.name)."
        }

        var summary = "### Analysis for \(person.name)\n\n"
        summary += "You've answered \(ratings.count) out of \(questions.count) questions.\n\n"

        // Simple analysis based on ratings
        let averageRating = Double(ratings.values.reduce(0, +)) / Double(ratings.count)
        summary += "Your average rating is \(String(format: "%.1f", averageRating)) out of 5.\n\n"

        if averageRating > 4 {
            summary +=
                "Overall, you seem to have a very positive outlook on your relationship with \(person.name)!\n"
        } else if averageRating > 3 {
            summary +=
                "You have a generally positive view of your relationship with \(person.name), with some areas to explore.\n"
        } else {
            summary +=
                "It looks like there are some key areas you might want to discuss with \(person.name).\n"
        }

        return summary
    }
}
