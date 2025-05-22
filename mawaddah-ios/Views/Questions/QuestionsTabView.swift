import SwiftUI

struct QuestionsTabView: View {
    @StateObject private var viewModel = QuestionDeckViewModel()
    @State private var showQuestionPicker = false

    var body: some View {
        VStack {
            SwipeableFlashcardView(viewModel: viewModel)
            QuestionPickerButton(viewModel: viewModel, showQuestionPicker: $showQuestionPicker)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 30)
        }
        .background(Color.purple.opacity(0.3).ignoresSafeArea())
    }
} 