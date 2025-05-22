import SwiftUI

struct QuestionPickerButton: View {
    @ObservedObject var viewModel: QuestionDeckViewModel
    @Binding var showQuestionPicker: Bool

    // Use shared colors
    private let cardColour = QuestionColors.cardColour
    private let borderColour = QuestionColors.borderColour

    var body: some View {
        Button {
            showQuestionPicker = true
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(cardColour)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(borderColour, lineWidth: 2)
                    )
                Text("Question \(viewModel.index + 1) of \(viewModel.questions.count)")
                    .font(.headline)
                    .foregroundColor(.black)
            }
            .frame(width: 350, height: 50)
        }
        .sheet(isPresented: $showQuestionPicker) {
            NavigationStack {
                List(viewModel.questions) { question in
                    Button {
                        if let newIndex = viewModel.questions.firstIndex(where: { $0.id == question.id }) {
                            viewModel.index = newIndex
                        }
                        showQuestionPicker = false
                    } label: {
                        HStack {
                            Text("\(question.id).")
                                .foregroundColor(.gray)
                            Text(question.text)
                                .foregroundColor(.primary)
                            Spacer()
                            if question.id == viewModel.currentQuestion.id {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                .navigationTitle("Select Question")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") { showQuestionPicker = false }
                    }
                }
            }
        }
    }
} 