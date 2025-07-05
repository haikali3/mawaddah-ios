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
  @StateObject private var partnerStore = PartnerStore.shared

  // Add explicit public initializer
  init(
    question: Question,
    rating: Binding<Int>,
    isInteractive: Bool,
    onPrevious: (() -> Void)? = nil,
    onNext: (() -> Void)? = nil,
    onRandom: (() -> Void)? = nil,
    isPreviousDisabled: Bool = false,
    isNextDisabled: Bool = false,
    isRandomDisabled: Bool = false
  ) {
    self.question = question
    self._rating = rating
    self.isInteractive = isInteractive
    self.onPrevious = onPrevious
    self.onNext = onNext
    self.onRandom = onRandom
    self.isPreviousDisabled = isPreviousDisabled
    self.isNextDisabled = isNextDisabled
    self.isRandomDisabled = isRandomDisabled
  }

  var body: some View {
    RoundedRectangle(cornerRadius: 30)
      .fill(QuestionColors.cardColour)
      .overlay(
        RoundedRectangle(cornerRadius: 30)
          .stroke(QuestionColors.borderColour, lineWidth: 2)
      )
      .overlay(content)
      .padding(30)
  }

  @ViewBuilder
  private var content: some View {
    ZStack {
      // Main content stacked at the top
      VStack {
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
                .background(QuestionColors.borderColour)
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
      }
      // Partner selection header pinned to top
      Group {
        if let selected = partnerStore.partners.first(where: {
          $0.id == partnerStore.selectedPartnerID
        }
        ) {
          Text("\(selected.name)")
            .font(.headline)
            .foregroundColor(QuestionColors.borderColour)
        } else {
          Text("No partner selected")
            .font(.headline)
            .foregroundColor(.gray)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
      .padding(.top, 20)
      // Bottom navigation and randomizer buttons aligned to bottom
      HStack(spacing: 30) {
        Button(action: { onPrevious?() }) {
          Label("Previous", systemImage: "chevron.left")
            .labelStyle(IconOnlyLabelStyle())
            .font(.title2)
            .foregroundColor(isPreviousDisabled ? .gray : QuestionColors.borderColour)
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
            .foregroundColor(isRandomDisabled ? .gray : QuestionColors.borderColour)
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
            .foregroundColor(isNextDisabled ? .gray : QuestionColors.borderColour)
            .padding(12)
            .background(Color.purple.opacity(0.15))
            .clipShape(Circle())
        }
        .disabled(isNextDisabled)
        .opacity(isNextDisabled ? 0.4 : 1.0)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
      .padding(.bottom, 20)
    }
  }
}

#Preview {
  CardView(
    question: Question(
      id: 1, text: "What is your concept of marriage?", tags: ["Marriage", "Values"]),
    rating: .constant(3),
    isInteractive: true
  )
}
