import SwiftUI

struct CardView: View {
    let question: Question
    @Binding var rating: Int
    let isInteractive: Bool

    // Centralised styling
    private let cardColour = Color(red: 238/255, green: 219/255, blue: 248/255)
    private let borderColour = Color(red: 80/255, green: 0/255, blue: 80/255)

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