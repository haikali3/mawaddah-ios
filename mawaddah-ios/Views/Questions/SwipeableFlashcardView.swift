import SwiftUI

struct SwipeableFlashcardView: View {
    @ObservedObject var viewModel: QuestionDeckViewModel
    @State private var offset = CGSize.zero
    @State private var isAnimating = false          // true while a card is sliding

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

            // Current card
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
                        .onChanged { gesture in
                            if !isAnimating { offset = gesture.translation }
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
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }

    // MARK: - Private helpers
    /// Handles what happens when the user lets go of a drag.
    private func handleSwipeEnd() {
        guard !isAnimating else { return }

        let swipedRight = offset.width > 0                // capture BEFORE reset
        if abs(offset.width) > swipeThreshold {
            isAnimating = true
            withAnimation(.easeOut(duration: 0.2)) {
                offset = CGSize(width: swipedRight ? 1000 : -1000, height: 0)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                // Navigate first …
                if swipedRight {
                    viewModel.showNextCard()
                } else {
                    viewModel.showPreviousCard()
                }
                // … then reset offset.
                withAnimation { offset = .zero }
                isAnimating = false
            }
        } else {
            withAnimation { offset = .zero }
        }
    }

    /// Slides the card off-screen via buttons.
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
            // Then reset offset
            withAnimation { offset = .zero }
            isAnimating = false
        }
    }
}
