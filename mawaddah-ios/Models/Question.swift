import Foundation

/// Represents a single relationship-assessment question.
///
/// Conforms to `Identifiable`, `Codable`, and `Hashable` so that it works
/// seamlessly with SwiftUI lists, JSON decoding, and collections.
struct Question: Identifiable, Codable, Hashable {
    let id: Int
    let text: String
    let tags: [String]
}
