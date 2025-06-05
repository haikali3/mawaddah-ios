import SwiftUI

struct SwipeableFlashcardView: View {
  @ObservedObject var viewModel: QuestionDeckViewModel
  @State private var offset = CGSize.zero
  @State private var isAnimating = false  // true while a card is sliding
  @EnvironmentObject var personStore: PersonStore

  private let borderColour = QuestionColors.borderColour
  private let swipeThreshold: CGFloat = 100

  private var isDragging: Bool {
    offset.width != 0
  }

  private var previousQuestion: Question? {
    let prevIndex = viewModel.index - 1
    return prevIndex >= 0 ? viewModel.questions[prevIndex] : nil
  }

  var body: some View {
    ZStack {
      // Card behind during a drag (either next or previous)
      if isDragging {
        if offset.width > 0, let next = viewModel.nextQuestion {
          CardView(
            question: next,
            rating: Binding(
              get: { viewModel.ratings[next.id] ?? 3 },
              set: { viewModel.ratings[next.id] = $0 }
            ),
            isInteractive: false
          )
          .zIndex(0)
        } else if offset.width < 0, let prev = previousQuestion {
          CardView(
            question: prev,
            rating: Binding(
              get: { viewModel.ratings[prev.id] ?? 3 },
              set: { viewModel.ratings[prev.id] = $0 }
            ),
            isInteractive: false
          )
          .zIndex(0)
        }
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
          onRandom: {
            if !isAnimating {
              viewModel.showRandomCard()
            }
          },
          isPreviousDisabled: viewModel.index == 0 || isAnimating,
          isNextDisabled: viewModel.index == viewModel.questions.count - 1 || isAnimating,
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

    // If didn't pass threshold or at bounds, spring back
    if !passedThreshold {
      withAnimation { offset = .zero }
      return
    }
    if swipedRight, viewModel.nextQuestion == nil {
      withAnimation { offset = .zero }
      return
    }
    if !swipedRight, viewModel.index == 0 {
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
