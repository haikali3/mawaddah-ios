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
            SwipableFlashCardView(currentIndex: $selectedQuestion, questions: questions)
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

struct SwipableFlashCardView: View {
    @Binding var currentIndex: Int
    let questions: [String]
    @State private var offset = CGSize.zero
    @State private var isSwiped = false

    var body: some View {
        if currentIndex < questions.count {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white.opacity(0.3))
                .overlay(
                    Text(questions[currentIndex])
                        .font(.title)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding()
                )
                .padding(30)
                .offset(x: offset.width, y: 0)
                .rotationEffect(.degrees(Double(offset.width / 20)))
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            offset = gesture.translation
                        }
                        .onEnded { _ in
                            if abs(offset.width) > 100 {
                                withAnimation {
                                    isSwiped = true
                                    offset = CGSize(width: offset.width > 0 ? 1000 : -1000, height: 0)
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    offset = .zero
                                    isSwiped = false
                                    if currentIndex < questions.count - 1 {
                                        currentIndex += 1
                                    }
                                }
                            } else {
                                withAnimation {
                                    offset = .zero
                                }
                            }
                        }
                )
                .animation(.spring(), value: offset)
        } else {
            Text("No more questions!")
                .font(.title)
                .foregroundColor(.black)
        }
    }
} 