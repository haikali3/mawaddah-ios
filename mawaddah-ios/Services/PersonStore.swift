import Foundation

/// Manages persons and their ratings, with persistence using UserDefaults.
struct PersonStore {
  static let shared = PersonStore()
  
  private init() {}
  
  // MARK: - Data Access
  var persons: [Person] {
    get { loadPersons() }
    set { savePersons(newValue) }
  }
  
  var selectedPersonID: UUID? {
    get { loadSelectedPersonID() }
    set { saveSelectedPersonID(newValue) }
  }
  
  var ratings: [UUID: [Int: Int]] {
    get { loadRatings() }
    set { saveRatings(newValue) }
  }

  // MARK: - Private Keys
  private let personsKey = "persons"
  private let selectedPersonKey = "selectedPerson"
  private let ratingsKey = "ratings"

  // MARK: - Private Loading Methods
  private func loadPersons() -> [Person] {
    let defaults = UserDefaults.standard
    if let data = defaults.data(forKey: personsKey),
       let decoded = try? JSONDecoder().decode([Person].self, from: data) {
      return decoded
    } else {
      let defaultPerson = Person(id: UUID(), name: "Person 1")
      return [defaultPerson]
    }
  }
  
  private func loadSelectedPersonID() -> UUID? {
    let defaults = UserDefaults.standard
    if let idData = defaults.data(forKey: selectedPersonKey),
       let id = try? JSONDecoder().decode(UUID.self, from: idData) {
      return id
    } else {
      return loadPersons().first?.id
    }
  }
  
  private func loadRatings() -> [UUID: [Int: Int]] {
    let defaults = UserDefaults.standard
    if let ratingsData = defaults.data(forKey: ratingsKey),
       let decodedRatings = try? JSONDecoder().decode([UUID: [Int: Int]].self, from: ratingsData) {
      return decodedRatings
    } else {
      return [:]
    }
  }

  // MARK: - Private Saving Methods
  private func savePersons(_ persons: [Person]) {
    let defaults = UserDefaults.standard
    if let data = try? JSONEncoder().encode(persons) {
      defaults.set(data, forKey: personsKey)
    }
  }
  
  private func saveSelectedPersonID(_ id: UUID?) {
    let defaults = UserDefaults.standard
    if let selected = id,
       let idData = try? JSONEncoder().encode(selected) {
      defaults.set(idData, forKey: selectedPersonKey)
    }
  }
  
  private func saveRatings(_ ratings: [UUID: [Int: Int]]) {
    let defaults = UserDefaults.standard
    if let ratingsData = try? JSONEncoder().encode(ratings) {
      defaults.set(ratingsData, forKey: ratingsKey)
    }
  }

  // MARK: - Public Methods
  mutating func addPerson(name: String) {
    let newPerson = Person(id: UUID(), name: name)
    var currentPersons = persons
    currentPersons.append(newPerson)
    persons = currentPersons
    selectedPersonID = newPerson.id
  }

  mutating func selectPerson(_ person: Person) {
    selectedPersonID = person.id
  }

  mutating func setRating(questionID: Int, rating: Int) {
    guard let pid = selectedPersonID else { return }
    var currentRatings = ratings
    var personRatings = currentRatings[pid] ?? [:]
    personRatings[questionID] = rating
    currentRatings[pid] = personRatings
    ratings = currentRatings
  }

  func getRatingsForSelected() -> [Int: Int] {
    guard let pid = selectedPersonID else { return [:] }
    return ratings[pid] ?? [:]
  }

  mutating func removePerson(at offsets: IndexSet) {
    var currentPersons = persons
    var currentRatings = ratings
    
    // Remove ratings for deleted persons
    for index in offsets {
      let id = currentPersons[index].id
      currentRatings.removeValue(forKey: id)
    }
    // Remove persons from the list
    currentPersons.remove(atOffsets: offsets)
    
    // If the selected person was deleted, select the first person
    if let selected = selectedPersonID,
       !currentPersons.contains(where: { $0.id == selected }) {
      selectedPersonID = currentPersons.first?.id
    }
    
    persons = currentPersons
    ratings = currentRatings
  }
}
