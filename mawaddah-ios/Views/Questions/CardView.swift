import SwiftUI

struct CardView: View {
  let question: Question
  @Binding var rating: Int
  let isInteractive: Bool
  var onPrevious: (() -> Void)? = nil
  var onNext: (() -> Void)? = nil
  var onRandom: (() -> Void)? = nil
  var isPreviousDisabled: Bool = false
  var isNextDisabled: Bool = false
  var isRandomDisabled: Bool = false
  @EnvironmentObject var personStore: PersonStore

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
      // Person selection
      if let selected = personStore.persons.first(where: { $0.id == personStore.selectedPersonID })
      {
        Text("\(selected.name)")
          .font(.headline)
          .foregroundColor(borderColour)
          .padding(.bottom, 20)
      } else {
        Text("No partner selected")
          .font(.headline)
          .foregroundColor(.gray)
          .padding(.bottom, 20)
      }

      Text("Question \(question.id)")
        .font(.headline)
        .foregroundColor(.black)
        .padding(.bottom, 40)
      Text(question.text)
        .font(.title3)
        .foregroundColor(.black)
        .multilineTextAlignment(.center)
        .padding(.horizontal, 20)
      // Tags display
      if !question.tags.isEmpty {
        HStack(spacing: 5) {
          ForEach(question.tags, id: \.self) { tag in
            Text(tag)
              .font(.caption)
              .foregroundColor(.white)
              .padding(.horizontal, 10)
              .padding(.vertical, 5)
              .background(borderColour)
              .cornerRadius(12)
          }
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 10)
      }

      VStack {
        HeartRatingView(rating: $rating, isInteractive: isInteractive)
          .padding(.bottom, 18)
        Text("Tap on the emotes to rate the question")
          .font(.caption)
          .foregroundColor(.gray)
        Text("Swipe right for next card, left for previous")
          .font(.caption)
          .foregroundColor(.gray)
      }
      .padding(.top, 40)

      // Accessibility navigation buttons inside the card
      Spacer()
      HStack(spacing: 30) {
        Button(action: { onPrevious?() }) {
          Label("Previous", systemImage: "chevron.left")
            .labelStyle(IconOnlyLabelStyle())
            .font(.title2)
            .foregroundColor(isPreviousDisabled ? .gray : borderColour)
            .padding(12)
            .background(Color.purple.opacity(0.15))
            .clipShape(Circle())
        }
        .disabled(isPreviousDisabled)
        .opacity(isPreviousDisabled ? 0.4 : 1.0)
        Button(action: { onRandom?() }) {
          Label("Random", systemImage: "dice")
            .labelStyle(IconOnlyLabelStyle())
            .font(.title2)
            .foregroundColor(isRandomDisabled ? .gray : borderColour)
            .padding(12)
            .background(Color.purple.opacity(0.15))
            .clipShape(Circle())
        }
        .disabled(isRandomDisabled)
        .opacity(isRandomDisabled ? 0.4 : 1.0)
        Button(action: { onNext?() }) {
          Label("Next", systemImage: "chevron.right")
            .labelStyle(IconOnlyLabelStyle())
            .font(.title2)
            .foregroundColor(isNextDisabled ? .gray : borderColour)
            .padding(12)
            .background(Color.purple.opacity(0.15))
            .clipShape(Circle())
        }
        .disabled(isNextDisabled)
        .opacity(isNextDisabled ? 0.4 : 1.0)
      }
      .padding(.bottom, 20)
    }
  }
}
