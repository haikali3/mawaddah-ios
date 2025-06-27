import Foundation
import SwiftUI

/// Represents a partner to be rated.
struct Partner: Identifiable, Codable, Hashable {
  let id: UUID
  var name: String
}

/// Manages partners and their ratings, with persistence using UserDefaults.
class PartnerStore: ObservableObject {
  static let shared = PartnerStore()

  @Published var partners: [Partner] = []
  @Published var selectedPartnerID: UUID?
  @Published var ratings: [UUID: [Int: Int]] = [:]

  private init() {
    loadData()
  }

  // MARK: - Private Keys
  private let partnersKey = "partners"
  private let selectedPartnerKey = "selectedPartner"
  private let ratingsKey = "ratings"

  // MARK: - Data Loading
  private func loadData() {
    partners = loadPartners()
    selectedPartnerID = loadSelectedPartnerID()
    ratings = loadRatings()
  }

  private func loadPartners() -> [Partner] {
    let defaults = UserDefaults.standard
    if let data = defaults.data(forKey: partnersKey),
      let decoded = try? JSONDecoder().decode([Partner].self, from: data)
    {
      return decoded
    } else {
      let defaultPartner = Partner(id: UUID(), name: "Partner 1")
      return [defaultPartner]
    }
  }

  private func loadSelectedPartnerID() -> UUID? {
    let defaults = UserDefaults.standard
    if let idData = defaults.data(forKey: selectedPartnerKey),
      let id = try? JSONDecoder().decode(UUID.self, from: idData)
    {
      return id
    } else {
      return loadPartners().first?.id
    }
  }

  private func loadRatings() -> [UUID: [Int: Int]] {
    let defaults = UserDefaults.standard
    if let ratingsData = defaults.data(forKey: ratingsKey),
      let decodedRatings = try? JSONDecoder().decode([UUID: [Int: Int]].self, from: ratingsData)
    {
      return decodedRatings
    } else {
      return [:]
    }
  }

  // MARK: - Private Saving Methods
  private func savePartners() {
    let defaults = UserDefaults.standard
    if let data = try? JSONEncoder().encode(partners) {
      defaults.set(data, forKey: partnersKey)
    }
  }

  private func saveSelectedPartnerID() {
    let defaults = UserDefaults.standard
    if let selected = selectedPartnerID,
      let idData = try? JSONEncoder().encode(selected)
    {
      defaults.set(idData, forKey: selectedPartnerKey)
    }
  }

  private func saveRatings() {
    let defaults = UserDefaults.standard
    if let ratingsData = try? JSONEncoder().encode(ratings) {
      defaults.set(ratingsData, forKey: ratingsKey)
    }
  }

  // MARK: - Public Methods
  func addPartner(name: String) {
    let newPartner = Partner(id: UUID(), name: name)
    partners.append(newPartner)
    selectedPartnerID = newPartner.id
    savePartners()
    saveSelectedPartnerID()
  }

  func selectPartner(_ partner: Partner) {
    selectedPartnerID = partner.id
    saveSelectedPartnerID()
  }

  func setRating(questionID: Int, rating: Int) {
    guard let pid = selectedPartnerID else { return }
    if ratings[pid] == nil {
      ratings[pid] = [:]
    }
    ratings[pid]?[questionID] = rating
    saveRatings()
  }

  func getRatingsForSelected() -> [Int: Int] {
    guard let pid = selectedPartnerID else { return [:] }
    return ratings[pid] ?? [:]
  }

  func removePartner(at offsets: IndexSet) {
    // Remove ratings for deleted partners
    for index in offsets {
      let id = partners[index].id
      ratings.removeValue(forKey: id)
    }

    // Remove partners from the list
    partners.remove(atOffsets: offsets)

    // If the selected partner was deleted, select the first partner
    if let selected = selectedPartnerID,
      !partners.contains(where: { $0.id == selected })
    {
      selectedPartnerID = partners.first?.id
    }

    savePartners()
    saveSelectedPartnerID()
    saveRatings()
  }

  func deleteAllRatingsForSelected() {
    guard let selectedID = selectedPartnerID else { return }
    ratings[selectedID] = [:]
    saveRatings()
  }
}
