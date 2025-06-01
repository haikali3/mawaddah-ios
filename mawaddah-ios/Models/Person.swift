import Foundation

/// Represents a person to be rated.
/// Conforms to `Identifiable`, `Codable`, and `Hashable` for storage and SwiftUI lists.
struct Person: Identifiable, Codable, Hashable {
  let id: UUID
  var name: String
}
