import SwiftUI

struct SwipeableFlashcardView: View {
  @ObservedObject var viewModel: QuestionDeckViewModel
  @State private var offset = CGSize.zero
  @State private var isAnimating = false  // true while a card is sliding

  private let borderColour = QuestionColors.borderColour
  private let swipeThreshold: CGFloat = 100

  private var isDragging: Bool {
    offset.width != 0
  }

  var body: some View {
    ZStack {
      // Next card (only visible during a drag)
      if isDragging, let next = viewModel.nextQuestion {
        CardView(
          question: next,
          rating: Binding(
            get: { viewModel.ratings[next.id] ?? 3 },
            set: { viewModel.ratings[next.id] = $0 }
          ),
          isInteractive: false
        )
        .zIndex(0)
      }

      // Current card or "no more" message
      if let question = viewModel.currentQuestion {
        CardView(
          question: question,
          rating: Binding(
            get: { viewModel.ratings[question.id] ?? 3 },
            set: { viewModel.ratings[question.id] = $0 }
          ),
          isInteractive: true,
          onPrevious: {
            if !isAnimating && viewModel.index > 0 {
              animateToNextCard(direction: -1)
            }
          },
          onNext: {
            if !isAnimating && viewModel.index < viewModel.questions.count - 1 {
              animateToNextCard(direction: 1)
            }
          },
          isPreviousDisabled: viewModel.index == 0 || isAnimating,
          isNextDisabled: viewModel.index == viewModel.questions.count - 1 || isAnimating
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
          .foregroundColor(borderColour)
      }
    }
  }

  // MARK: - Private helpers
  /// Handles what happens when the user lets go of a drag.
  private func handleSwipeEnd() {
    guard !isAnimating else { return }

    let swipedRight = offset.width > 0
    let passedThreshold = abs(offset.width) > swipeThreshold

    // If you swipe past threshold but there's nowhere to go, just spring back
    if passedThreshold {
      if swipedRight, viewModel.nextQuestion == nil {
        withAnimation { offset = .zero }
        return
      }
      if !swipedRight, viewModel.index == 0 {
        withAnimation { offset = .zero }
        return
      }
    } else {
      // Didn't pass threshold → just spring back
      withAnimation { offset = .zero }
      return
    }

    // Otherwise animate off-screen then change index
    isAnimating = true
    withAnimation(.easeOut(duration: 0.4)) {
      offset = CGSize(width: swipedRight ? 1000 : -1000, height: 0)
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
      if swipedRight {
        viewModel.showNextCard()
      } else {
        viewModel.showPreviousCard()
      }
      withAnimation { offset = .zero }
      isAnimating = false
    }
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
        viewModel.showNextCard()
      } else {
        viewModel.showPreviousCard()
      }
      // Then reset offset immediately without animation
      offset = .zero
      isAnimating = false
    }
  }
}
