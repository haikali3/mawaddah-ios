import Foundation

extension Array where Element == Question {
  /// Returns questions filtered by search text and selected tags.
  func filtered(by searchText: String, tags: Set<String>) -> [Question] {
    filter { question in
      (searchText.isEmpty || question.text.localizedCaseInsensitiveContains(searchText))
        && (tags.isEmpty || !Set(question.tags).isDisjoint(with: tags))
    }
  }

  /// Returns all unique tags from questions.
  func uniqueTags() -> [String] {
    Set(flatMap { $0.tags }).sorted()
  }
}
