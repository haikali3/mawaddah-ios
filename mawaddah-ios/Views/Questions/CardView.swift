import SwiftUI

struct CardView: View {
    let question: Question
    @Binding var rating: Int
    let isInteractive: Bool
    var onPrevious: (() -> Void)? = nil
    var onNext: (() -> Void)? = nil
    var isPreviousDisabled: Bool = false
    var isNextDisabled: Bool = false
    

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
                .padding(.bottom, 40)
            Text(question.text)
                .font(.title3)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
            // Tags display
            if !question.tags.isEmpty {
                HStack(spacing: 3) {
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
                Text("Tap on the emotes to rate the question")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("Swipe left to skip, swipe right to rate") 
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.top, 8)
            // Accessibility navigation buttons inside the card
            HStack(spacing: 30) {
                Button(action: { onPrevious?() }) {
                    Label("Previous", systemImage: "chevron.left")
                        .labelStyle(IconOnlyLabelStyle())
                        .font(.title2)
                        .foregroundColor(borderColour)
                        .padding(12)
                        .background(
                            Circle()
                                .fill(Color.purple.opacity(0.15))
                                .overlay(
                                    Circle()
                                        .stroke(borderColour, lineWidth: 2)
                                )
                        )
                }
                .disabled(isPreviousDisabled)
                Button(action: { onNext?() }) {
                    Label("Next", systemImage: "chevron.right")
                        .labelStyle(IconOnlyLabelStyle())
                        .font(.title2)
                        .foregroundColor(borderColour)
                        .padding(12)
                        .background(
                            Circle()
                                .fill(Color.purple.opacity(0.15))
                                .overlay(
                                    Circle()
                                        .stroke(borderColour, lineWidth: 2)
                                )
                        )
                }
                .disabled(isNextDisabled)
            }
            .padding(.top, 12)
        }
    }
} 