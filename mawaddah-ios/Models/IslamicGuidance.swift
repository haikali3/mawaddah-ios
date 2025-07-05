//
//  IslamicGuidance.swift
//  mawaddah-ios
//
//  Created by Haikal Tahar on 05/07/2025.
//

import Foundation

struct IslamicGuidance: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let titleMalay: String
    let category: GuidanceCategory
    let content: String
    let contentMalay: String
    let source: String
    let sourceMalay: String
    let reference: String
    let tags: [String]
    let isQuran: Bool
    let isHadith: Bool
    
    enum GuidanceCategory: String, CaseIterable, Codable {
        case marriage = "Marriage"
        case courtship = "Courtship"
        case relationships = "Relationships"
        case family = "Family"
        case communication = "Communication"
        case conflict = "Conflict Resolution"
        case spirituality = "Spirituality"
        case rights = "Rights & Responsibilities"
        case ethics = "Ethics"
        case guidance = "General Guidance"
        
        var displayName: String {
            self.rawValue
        }
        
        var icon: String {
            switch self {
            case .marriage: return "heart.circle"
            case .courtship: return "person.2.circle"
            case .relationships: return "person.3.circle"
            case .family: return "house.circle"
            case .communication: return "message.circle"
            case .conflict: return "exclamationmark.triangle.circle"
            case .spirituality: return "moon.circle"
            case .rights: return "scale.3d"
            case .ethics: return "checkmark.circle"
            case .guidance: return "lightbulb.circle"
            }
        }
    }
}

class IslamicGuidanceRepository: ObservableObject {
    @Published var guidances: [IslamicGuidance] = []
    
    init() {
        loadGuidances()
    }
    
    private func loadGuidances() {
        // Sample Islamic guidance data
        guidances = [
            IslamicGuidance(
                id: UUID(),
                title: "Choosing a Life Partner",
                titleMalay: "Memilih Pasangan Hidup",
                category: .marriage,
                content: "When choosing a spouse, look for someone who is religious and of good character. The Prophet (peace be upon him) said: 'A woman is married for four things: her wealth, her family status, her beauty, and her religion. So you should marry the religious woman (otherwise) you will be a loser.'",
                contentMalay: "Apabila memilih pasangan, carilah seseorang yang beragama dan berakhlak baik. Nabi (saw) bersabda: 'Wanita dikahwini kerana empat perkara: hartanya, keturunannya, kecantikannya, dan agamanya. Maka pilihlah yang beragama, nescaya engkau akan beruntung.'",
                source: "Prophet Muhammad (PBUH)",
                sourceMalay: "Nabi Muhammad (saw)",
                reference: "Sahih al-Bukhari 5090",
                tags: ["marriage", "character", "religion", "choice"],
                isQuran: false,
                isHadith: true
            ),
            IslamicGuidance(
                id: UUID(),
                title: "Kindness Between Spouses",
                titleMalay: "Kebaikan Antara Suami Isteri",
                category: .relationships,
                content: "And among His signs is that He created for you from yourselves mates that you may find tranquility in them; and He placed between you affection and mercy. Indeed in that are signs for a people who give thought.",
                contentMalay: "Dan di antara tanda-tanda kekuasaan-Nya ialah Dia menciptakan untukmu isteri-isteri dari jenismu sendiri, supaya kamu cenderung dan merasa tenteram kepadanya, dan dijadikan-Nya di antaramu rasa kasih dan sayang. Sesungguhnya pada yang demikian itu benar-benar terdapat tanda-tanda bagi kaum yang berfikir.",
                source: "Quran",
                sourceMalay: "Al-Quran",
                reference: "Surah Ar-Rum 30:21",
                tags: ["marriage", "love", "mercy", "tranquility"],
                isQuran: true,
                isHadith: false
            ),
            IslamicGuidance(
                id: UUID(),
                title: "Treating Your Wife with Kindness",
                titleMalay: "Berlaku Baik Kepada Isteri",
                category: .relationships,
                content: "The Prophet (peace be upon him) said: 'The most perfect believer in faith is the one whose character is finest and who is kindest to his wife.'",
                contentMalay: "Nabi (saw) bersabda: 'Orang mukmin yang paling sempurna imannya adalah yang paling baik akhlaknya dan yang paling baik terhadap isterinya.'",
                source: "Prophet Muhammad (PBUH)",
                sourceMalay: "Nabi Muhammad (saw)",
                reference: "Sunan at-Tirmidhi 1162",
                tags: ["marriage", "kindness", "character", "husband"],
                isQuran: false,
                isHadith: true
            ),
            IslamicGuidance(
                id: UUID(),
                title: "Consultation in Marriage",
                titleMalay: "Bermusyawarah dalam Perkahwinan",
                category: .communication,
                content: "And those who have responded to their lord and established prayer and who conduct their affairs by mutual consultation and who spend of what We have provided them.",
                contentMalay: "Dan (bagi) orang-orang yang menerima (mematuhi) seruan Tuhannya dan mendirikan sembahyang, sedang urusan mereka (diputuskan) dengan musyawarat antara mereka; dan mereka menafkahkan sebahagian dari rezki yang Kami berikan kepada mereka.",
                source: "Quran",
                sourceMalay: "Al-Quran",
                reference: "Surah Ash-Shura 42:38",
                tags: ["marriage", "consultation", "decision", "mutual"],
                isQuran: true,
                isHadith: false
            ),
            IslamicGuidance(
                id: UUID(),
                title: "Patience in Relationships",
                titleMalay: "Sabar dalam Hubungan",
                category: .conflict,
                content: "The Prophet (peace be upon him) said: 'The believer is not one who eats his fill while his neighbor goes hungry.'",
                contentMalay: "Nabi (saw) bersabda: 'Bukanlah beriman orang yang kenyang sedangkan tetangganya kelaparan.'",
                source: "Prophet Muhammad (PBUH)",
                sourceMalay: "Nabi Muhammad (saw)",
                reference: "Al-Adab al-Mufrad 112",
                tags: ["patience", "neighbor", "empathy", "community"],
                isQuran: false,
                isHadith: true
            ),
            IslamicGuidance(
                id: UUID(),
                title: "Rights and Responsibilities",
                titleMalay: "Hak dan Tanggungjawab",
                category: .rights,
                content: "The Prophet (peace be upon him) said: 'Each of you is a shepherd and each of you is responsible for his flock.'",
                contentMalay: "Nabi (saw) bersabda: 'Setiap kamu adalah pemimpin dan setiap kamu akan diminta pertanggungjawaban tentang kepemimpinannya.'",
                source: "Prophet Muhammad (PBUH)",
                sourceMalay: "Nabi Muhammad (saw)",
                reference: "Sahih al-Bukhari 853",
                tags: ["responsibility", "leadership", "family", "accountability"],
                isQuran: false,
                isHadith: true
            ),
            IslamicGuidance(
                id: UUID(),
                title: "Seeking Guidance in Prayer",
                titleMalay: "Mencari Petunjuk dalam Solat",
                category: .spirituality,
                content: "The Prophet (peace be upon him) taught us to seek guidance through prayer (Istikhara) when making important decisions, especially regarding marriage.",
                contentMalay: "Nabi (saw) mengajar kita untuk mencari petunjuk melalui solat (Istikhara) ketika membuat keputusan penting, terutamanya berkaitan perkahwinan.",
                source: "Prophet Muhammad (PBUH)",
                sourceMalay: "Nabi Muhammad (saw)",
                reference: "Sahih al-Bukhari 1162",
                tags: ["prayer", "guidance", "decision", "istikhara"],
                isQuran: false,
                isHadith: true
            ),
            IslamicGuidance(
                id: UUID(),
                title: "Forgiveness in Marriage",
                titleMalay: "Pengampunan dalam Perkahwinan",
                category: .conflict,
                content: "But whoever forgives and makes reconciliation, his reward is with Allah. Surely He likes not the Zalimun (oppressors, polytheists, and wrong-doers).",
                contentMalay: "Tetapi barangsiapa yang memaafkan dan mengadakan perdamaian, maka pahalanya di sisi Allah. Sesungguhnya Allah tidak menyukai orang-orang yang zalim.",
                source: "Quran",
                sourceMalay: "Al-Quran",
                reference: "Surah Ash-Shura 42:40",
                tags: ["forgiveness", "reconciliation", "conflict", "peace"],
                isQuran: true,
                isHadith: false
            )
        ]
    }
    
    func guidancesByCategory(_ category: IslamicGuidance.GuidanceCategory) -> [IslamicGuidance] {
        return guidances.filter { $0.category == category }
    }
    
    func searchGuidances(query: String) -> [IslamicGuidance] {
        if query.isEmpty {
            return guidances
        }
        return guidances.filter { guidance in
            guidance.title.localizedCaseInsensitiveContains(query) ||
            guidance.titleMalay.localizedCaseInsensitiveContains(query) ||
            guidance.content.localizedCaseInsensitiveContains(query) ||
            guidance.contentMalay.localizedCaseInsensitiveContains(query) ||
            guidance.tags.contains { $0.localizedCaseInsensitiveContains(query) }
        }
    }
}