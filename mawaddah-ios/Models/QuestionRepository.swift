import Foundation

/// Loads questions from a bundled `questions-en.json` file.
/// Falls back to a hard-coded array if the file cannot be read or decoded.
enum QuestionRepository {

    /// Returns all bundled questions.
    static func loadAll() -> [Question] {
        if let url = Bundle.main.url(forResource: "questions-en", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let questions = try? JSONDecoder().decode([Question].self, from: data) {
            return questions
        }

        // Fallback — keeps the app usable even if the JSON is missing.
        return fallbackQuestions
    }

    // MARK: - Private

    /// Hard-coded questions that mirror the original `Questions.allQuestions` list.
    private static let fallbackQuestions: [Question] = [
        Question(id: 1, text: "What is your concept of marriage?", tags: ["Marriage", "Values"]),
        Question(id: 2, text: "Have you ever been married before?", tags: ["Marriage", "History"]),
        Question(id: 3, text: "Are you married now?", tags: ["Marriage", "Status"]),
        Question(id: 4, text: "What are your expectations of marriage?", tags: ["Marriage", "Expectations"]),
        Question(id: 5, text: "What are your goals in life? Long term and short term plans.", tags: ["Lifestyle", "Goals"]),
        Question(
            id: 6, 
            text: "Identify three things that you want to accomplish in the near future.", 
            tags: ["Lifestyle", "Goals"]
        ),
        Question(id: 7, text: "Identify three things that you want to accomplish, long-term.", tags: ["Lifestyle", "Goals"]),
        Question(id: 8, text: "Why have you chosen me as your potential spouse?", tags: ["Marriage", "Personal"]),
        Question(id: 9, text: "What is the role of religion in your life – now?", tags: ["Religion", "Personal"]),
        Question(id: 10, text: "Are you a spiritual person?", tags: ["Religion", "Personal"]),
    ]
}