import SwiftUI

struct CardView: View {
    let question: Question
    @Binding var rating: Int
    let isInteractive: Bool

    // Use shared colors
    private let cardColour = QuestionColors.cardColour
    private let borderColour = QuestionColors.borderColour

    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .fill(cardColour)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(borderColour, lineWidth: 2)
            )
            .overlay(content)
            .padding(30)
    }

    @ViewBuilder
    private var content: some View {
        VStack {
            Text("Question \(question.id)")
                .font(.headline)
                .foregroundColor(.black)
                .padding(.bottom, 10)
            Text(question.text)
                .font(.title3)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding()
            // Tags display
            if !question.tags.isEmpty {
                HStack(spacing: 8) {
                    ForEach(question.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.purple.opacity(0.7))
                            .cornerRadius(12)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 10)
            }
            VStack(spacing: 4) {
                HeartRatingView(rating: $rating, isInteractive: isInteractive)
                    .padding(.bottom, 18)
                Text("🤍 = Negative ❤️ = Positive")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.top, 8)
        }
    }
} 