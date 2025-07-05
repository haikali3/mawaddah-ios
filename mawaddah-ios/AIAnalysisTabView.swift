import SwiftUI

struct AIAnalysisTabView: View {
  let questions: [Question] = QuestionRepository.loadAll()
  @StateObject private var partnerStore = PartnerStore.shared
  @State private var analysis: String = ""
  @State private var isLoading: Bool = false

  var body: some View {
    ZStack {
      Color.appBackground.ignoresSafeArea()
      VStack {
        if isLoading {
          ProgressView("Analyzing...")
        } else {
          ScrollView {
            Text(analysis)
              .padding()
          }
        }

        Button(action: {
          generateAnalysis()
        }) {
          Text("Generate Analysis")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(QuestionColors.borderColour)
            .cornerRadius(10)
        }
        .padding()
      }
      .onAppear {
        if analysis.isEmpty {
          generateAnalysis()
        }
      }
    }
  }

  private func generateAnalysis() {
    isLoading = true
    analysis = ""

    DispatchQueue.global(qos: .userInitiated).async {
      let summary = createSummary()

      DispatchQueue.main.async {
        self.analysis = summary
        self.isLoading = false
      }
    }
  }

  private func createSummary() -> String {
    guard let partnerID = partnerStore.selectedPartnerID,
      let partner = partnerStore.partners.first(where: { $0.id == partnerID })
    else {
      return "Please select a partner first."
    }

    let ratings = partnerStore.getRatingsForSelected()

    if ratings.isEmpty {
      return "No analysis available. Please answer some questions for \(partner.name)."
    }

    // Placeholder Analysis
    var summary = "### Analysis for \(partner.name)\n\n"
    summary += "You've answered \(ratings.count) out of \(questions.count) questions.\n\n"
    let averageRating = Double(ratings.values.reduce(0, +)) / Double(ratings.count)
    summary += "Your average rating is \(String(format: "%.1f", averageRating)) out of 5.\n\n"
    if averageRating > 4 {
      summary +=
        "Overall, you seem to have a very positive outlook on your relationship with \(partner.name)!\n"
    } else if averageRating > 3 {
      summary +=
        "You have a generally positive view of your relationship with \(partner.name), with some areas to explore.\n"
    } else {
      summary +=
        "It looks like there are some key areas you might want to discuss with \(partner.name).\n"
    }
    summary +=
      "\n\n--- \n*This is a placeholder analysis. Replace with a real Core ML model for full functionality.*"

    return summary
  }
}

#Preview {
  AIAnalysisTabView()
}
