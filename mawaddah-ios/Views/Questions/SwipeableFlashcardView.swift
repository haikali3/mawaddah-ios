import SwiftUI

struct SwipeableFlashcardView: View {
    @ObservedObject var viewModel: QuestionDeckViewModel
    @State private var offset = CGSize.zero

    private let swipeThreshold: CGFloat = 100

    private var isDragging: Bool {
        offset.width != 0
    }

    var body: some View {
        ZStack {
            // Next card (visible only while dragging)
            if isDragging, viewModel.index + 1 < viewModel.questions.count {
                CardView(
                    question: viewModel.questions[viewModel.index + 1],
                    rating: Binding(
                        get: { viewModel.ratings[viewModel.questions[viewModel.index + 1].id] ?? 3 },
                        set: { viewModel.ratings[viewModel.questions[viewModel.index + 1].id] = $0 }
                    ),
                    isInteractive: false
                )
                .zIndex(0)
            }

            // Current card (always visible)
            CardView(
                question: viewModel.currentQuestion,
                rating: Binding(
                    get: { viewModel.ratings[viewModel.currentQuestion.id] ?? 3 },
                    set: { viewModel.ratings[viewModel.currentQuestion.id] = $0 }
                ),
                isInteractive: true,
                onPrevious: {
                    if viewModel.index > 0 {
                        viewModel.index -= 1
                    }
                },
                onNext: {
                    if viewModel.index < viewModel.questions.count - 1 {
                        viewModel.index += 1
                    }
                },
                isPreviousDisabled: viewModel.index == 0,
                isNextDisabled: viewModel.index == viewModel.questions.count - 1
            )
            .offset(x: offset.width)
            .rotationEffect(.degrees(Double(offset.width / 30)))
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        offset = gesture.translation
                    }
                    .onEnded { _ in
                        if abs(offset.width) > swipeThreshold {
                            withAnimation(.easeOut(duration: 0.2)) {
                                offset = CGSize(width: offset.width > 0 ? 1000 : -1000, height: 0)
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                offset = .zero
                                viewModel.showNextCard()
                            }
                        } else {
                            withAnimation { offset = .zero }
                        }
                    }
            )
            .zIndex(1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}