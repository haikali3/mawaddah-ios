import SwiftUI

struct QuestionPickerButton: View {
    @ObservedObject var viewModel: QuestionDeckViewModel
    @Binding var showQuestionPicker: Bool

    var body: some View {
        Button {
            showQuestionPicker = true
        } label: {
            Text("Question \(viewModel.index + 1) of \(viewModel.questions.count)")
                .frame(width: 350, height: 50)
                .background(Color.white.opacity(0.7))
                .cornerRadius(15)
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