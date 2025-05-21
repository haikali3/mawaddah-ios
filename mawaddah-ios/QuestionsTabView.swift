import SwiftUI

struct QuestionsTabView: View {
    @Binding var selectedQuestion: Int
    @Binding var showQuestionPicker: Bool
    let questions: [String]

    var body: some View {
        VStack(spacing: 20) {
            QuestionPickerButton(
                selectedQuestion: $selectedQuestion,
                showQuestionPicker: $showQuestionPicker,
                questions: questions
            )
            FlashCardView(question: questions[selectedQuestion])
        }
        .background(Color.purple.opacity(0.3).ignoresSafeArea())
    }
}

struct QuestionPickerButton: View {
    @Binding var selectedQuestion: Int
    @Binding var showQuestionPicker: Bool
    let questions: [String]

    var body: some View {
        Button(action: {
            showQuestionPicker = true
        }) {
            Text(questions[selectedQuestion])
                .frame(width: 100, height: 60)
                .background(Color.white.opacity(0.7))
                .cornerRadius(10)
        }
        .sheet(isPresented: $showQuestionPicker) {
            VStack {
                Picker("Select Question", selection: $selectedQuestion) {
                    ForEach(0..<questions.count, id: \.self) { index in
                        Text(questions[index]).tag(index)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .labelsHidden()
                .frame(height: 200)
                Button("Done") {
                    showQuestionPicker = false
                }
                .padding()
            }
        }
    }
}

struct FlashCardView: View {
    let question: String

    var body: some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(Color.white.opacity(0.3))
            .overlay(
                Text("Flash Card\n\(question)")
                    .font(.title)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
            )
            .padding(30)
    }
} 