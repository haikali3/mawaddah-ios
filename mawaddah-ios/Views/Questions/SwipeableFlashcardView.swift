import SwiftUI

struct SwipeableFlashcardView: View {
  let questions: [Question]
  @Binding var currentIndex: Int
  @Binding var ratings: [Int: Int]
  let onRatingChanged: (Int, Int) -> Void

  @State private var offset = CGSize.zero
  @State private var isAnimating = false

  private let swipeThreshold: CGFloat = 100

  private var isDragging: Bool {
    offset.width != 0
  }

  private var currentQuestion: Question? {
    guard currentIndex >= 0 && currentIndex < questions.count else { return nil }
    return questions[currentIndex]
  }

  private var nextQuestion: Question? {
    let next = currentIndex + 1
    return next < questions.count ? questions[next] : nil
  }

  private var previousQuestion: Question? {
    let prevIndex = currentIndex - 1
    return prevIndex >= 0 ? questions[prevIndex] : nil
  }

  var body: some View {
    ZStack {
      // Card behind during a drag (either next or previous)
      if isDragging {
        if offset.width > 0, let next = nextQuestion {
          CardView(
            question: next,
            rating: Binding(
              get: { ratings[next.id] ?? 3 },
              set: { _ in }
            ),
            isInteractive: false
          )
          .zIndex(0)
        } else if offset.width < 0, let prev = previousQuestion {
          CardView(
            question: prev,
            rating: Binding(
              get: { ratings[prev.id] ?? 3 },
              set: { _ in }
            ),
            isInteractive: false
          )
          .zIndex(0)
        }
      }

      // Current card or "no more" message
      if let question = currentQuestion {
        CardView(
          question: question,
          rating: Binding(
            get: { ratings[question.id] ?? 3 },
            set: { newRating in
              ratings[question.id] = newRating
              onRatingChanged(question.id, newRating)
            }
          ),
          isInteractive: true,
          onPrevious: {
            if !isAnimating && currentIndex > 0 {
              animateToNextCard(direction: -1)
            }
          },
          onNext: {
            if !isAnimating && currentIndex < questions.count - 1 {
              animateToNextCard(direction: 1)
            }
          },
          onRandom: {
            if !isAnimating {
              showRandomCard()
            }
          },
          isPreviousDisabled: currentIndex == 0 || isAnimating,
          isNextDisabled: currentIndex == questions.count - 1 || isAnimating,
          isRandomDisabled: isAnimating
        )
        .offset(x: offset.width)
        .rotationEffect(.degrees(Double(offset.width / 30)))
        .gesture(
          DragGesture()
            .onChanged { g in
              if !isAnimating { offset = g.translation }
            }
            .onEnded { _ in handleSwipeEnd() }
        )
        .zIndex(1)

      } else {
        Text("No more questions!")
          .font(.title)
          .foregroundColor(QuestionColors.borderColour)
      }
    }
  }

  // MARK: - Private helpers
  private func handleSwipeEnd() {
    guard !isAnimating else { return }

    let swipedRight = offset.width > 0
    let passedThreshold = abs(offset.width) > swipeThreshold

    // If didn't pass threshold or at bounds, spring back
    if !passedThreshold {
      withAnimation { offset = .zero }
      return
    }
    if swipedRight, nextQuestion == nil {
      withAnimation { offset = .zero }
      return
    }
    if !swipedRight, currentIndex == 0 {
      withAnimation { offset = .zero }
      return
    }

    // Otherwise use the same animation as buttons
    animateToNextCard(direction: swipedRight ? 1 : -1)
  }

  private func animateToNextCard(direction: CGFloat) {
    guard !isAnimating else { return }
    isAnimating = true

    withAnimation(.easeOut(duration: 0.4)) {
      offset = CGSize(width: direction * 1000, height: 0)
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
      // Change index FIRST
      if direction > 0 {
        showNextCard()
      } else {
        showPreviousCard()
      }
      // Then reset offset immediately without animation
      offset = .zero
      isAnimating = false
    }
  }

  private func showNextCard() {
    guard currentIndex < questions.count - 1 else { return }
    currentIndex += 1
  }

  private func showPreviousCard() {
    guard currentIndex > 0 else { return }
    currentIndex -= 1
  }

  private func showRandomCard() {
    guard !questions.isEmpty else { return }
    var newIndex: Int
    repeat {
      newIndex = Int.random(in: 0..<questions.count)
    } while questions.count > 1 && newIndex == currentIndex
    currentIndex = newIndex
  }
}

#Preview {
  SwipeableFlashcardView(
    questions: QuestionRepository.loadAll(),
    currentIndex: .constant(0),
    ratings: .constant([1: 3, 2: 4]),
    onRatingChanged: { _, _ in }
  )
}
