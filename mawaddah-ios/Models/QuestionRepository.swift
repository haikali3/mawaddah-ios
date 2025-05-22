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
        Question(id: 1, text: "What is your concept of marriage?"),
        Question(id: 2, text: "Have you ever been married before?"),
        Question(id: 3, text: "Are you married now?"),
        Question(id: 4, text: "What are your expectations of marriage?"),
        Question(id: 5, text: "What are your goals in life? Long term and short term plans."),
        Question(id: 6, text: "Identify three things that you want to accomplish in the near future."),
        Question(id: 7, text: "Identify three things that you want to accomplish, long-term."),
        Question(id: 8, text: "Why have you chosen me as your potential spouse?"),
        Question(id: 9, text: "What is the role of religion in your life – now?"),
        Question(id: 10, text: "Are you a spiritual person?"),
        Question(id: 11, text: "What is your understanding of an Islamic marriage?"),
        Question(id: 12, text: "What are you expecting of your spouse, religiously?"),
        Question(id: 13, text: "What is your relationship between yourself and the Muslim community in your area?"),
        Question(id: 14, text: "Are you volunteering in any Islamic activities?"),
        Question(id: 15, text: "What can you offer your mate, spiritually?"),
        Question(id: 16, text: "What is the role of a husband?"),
        Question(id: 17, text: "What is the role of a wife?"),
        Question(id: 18, text: "Do you want to practice polygamy?"),
        Question(id: 19, text: "What is your relationship with your family?"),
        Question(id: 20, text: "What do you expect your relationship to be like with the family of your spouse?"),
        Question(id: 21, text: "What do you expect the relationship between your spouse and your family to be like?"),
        Question(id: 22, text: "Is there anyone in your family that lives with you now?"),
        Question(id: 23, text: "Are you planning to have anyone in your family live with you in the future?"),
        Question(id: 24, text: "If for any reason my relationship with your family turns sour, what should be done?"),
        Question(id: 25, text: "Who are your friends? Identify at least three."),
        Question(id: 26, text: "How did you get to know them?"),
        Question(id: 27, text: "Why are they your friends?"),
        Question(id: 28, text: "What do you like most about them?"),
        Question(id: 29, text: "What will your relationship with them be like after marriage?"),
        Question(id: 30, text: "Do you have friends from the opposite sex?")
    ]
} 