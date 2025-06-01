import Foundation
import SwiftUI

/// Manages persons and their ratings, with persistence using UserDefaults.
@MainActor
final class PersonStore: ObservableObject {
  @Published var persons: [Person] = []  // List of persons
  @Published var selectedPersonID: UUID?  // Currently selected person
  @Published var ratings: [UUID: [Int: Int]] = [:]  // personID -> (questionID -> rating)

  private let personsKey = "persons"
  private let selectedPersonKey = "selectedPerson"
  private let ratingsKey = "ratings"

  init() {
    load()
  }

  /// Load persons, selected person, and ratings from UserDefaults.
  private func load() {
    let defaults = UserDefaults.standard
    // Load persons
    if let data = defaults.data(forKey: personsKey),
      let decoded = try? JSONDecoder().decode([Person].self, from: data)
    {
      persons = decoded
    } else {
      // Fallback to a default first person
      let defaultPerson = Person(id: UUID(), name: "Person 1")
      persons = [defaultPerson]
    }
    // Load selected person
    if let idData = defaults.data(forKey: selectedPersonKey),
      let id = try? JSONDecoder().decode(UUID.self, from: idData)
    {
      selectedPersonID = id
    } else {
      selectedPersonID = persons.first?.id
    }
    // Load ratings
    if let ratingsData = defaults.data(forKey: ratingsKey),
      let decodedRatings = try? JSONDecoder().decode([UUID: [Int: Int]].self, from: ratingsData)
    {
      ratings = decodedRatings
    } else {
      ratings = [:]
    }
  }

  /// Save current persons, selected person, and ratings to UserDefaults.
  private func save() {
    let defaults = UserDefaults.standard
    if let data = try? JSONEncoder().encode(persons) {
      defaults.set(data, forKey: personsKey)
    }
    if let selected = selectedPersonID,
      let idData = try? JSONEncoder().encode(selected)
    {
      defaults.set(idData, forKey: selectedPersonKey)
    }
    if let ratingsData = try? JSONEncoder().encode(ratings) {
      defaults.set(ratingsData, forKey: ratingsKey)
    }
  }

  /// Add a new person with the given name and select them.
  func addPerson(name: String) {
    let newPerson = Person(id: UUID(), name: name)
    persons.append(newPerson)
    selectedPersonID = newPerson.id
    save()
  }

  /// Select an existing person.
  func selectPerson(_ person: Person) {
    selectedPersonID = person.id
    save()
  }

  /// Update the rating for a question for the currently selected person.
  func setRating(questionID: Int, rating: Int) {
    guard let pid = selectedPersonID else { return }
    var personRatings = ratings[pid] ?? [:]
    personRatings[questionID] = rating
    ratings[pid] = personRatings
    save()
  }

  /// Get ratings for the currently selected person.
  func getRatingsForSelected() -> [Int: Int] {
    guard let pid = selectedPersonID else { return [:] }
    return ratings[pid] ?? [:]
  }
}
