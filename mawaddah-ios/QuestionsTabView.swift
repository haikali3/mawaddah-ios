import SwiftUI

struct QuestionsTabView: View {
    @Binding var selectedQuestion: Int
    @Binding var showQuestionPicker: Bool
    let questions: [String]
    
    var body: some View {
        VStack {
            // Spacer()
            SwipableFlashCardView(currentIndex: $selectedQuestion, questions: questions)
            // Spacer()
            QuestionPickerButton(
                selectedQuestion: $selectedQuestion,
                showQuestionPicker: $showQuestionPicker,
                questions: questions
            )
            .frame(maxWidth: .infinity) // Make button span full width
            // .padding(.horizontal) // Add some padding on sides
            .padding(.bottom, 30)
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
            Text("Question \(selectedQuestion + 1) of \(questions.count)")
                .frame(width: 350, height: 50)
                .background(Color.white.opacity(0.7))
                .cornerRadius(15)
        }
        .sheet(isPresented: $showQuestionPicker) {
            NavigationStack {
                List {
                    ForEach(0..<questions.count, id: \.self) { index in
                        Button(action: {
                            selectedQuestion = index
                            showQuestionPicker = false
                        }) {
                            HStack {
                                Text("\(index + 1).")
                                    .foregroundColor(.gray)
                                Text(questions[index])
                                    .foregroundColor(.primary)
                                Spacer()
                                if index == selectedQuestion {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Select Question")
                .navigationBarItems(trailing: Button("Done") {
                    showQuestionPicker = false
                })
            }
        }
    }
}

struct SwipableFlashCardView: View {
    @Binding var currentIndex: Int
    let questions: [String]
    @State private var offset = CGSize.zero

    var isDragging: Bool {
        offset.width != 0
    }

    var body: some View {
        ZStack {
            // Show next card only when dragging
            if isDragging, currentIndex + 1 < questions.count {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white.opacity(0.2))
                    .overlay(
                        VStack {
                            Text("Question \(currentIndex + 2)")
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding(.bottom, 10)
                            Text(questions[currentIndex + 1])
                                .font(.title3)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                    )
                    .padding(30)
                    .scaleEffect()
                    .offset()
                    .zIndex(0)
            }

            // Current card (always visible)
            if currentIndex < questions.count {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white.opacity(0.3)) // Make current card fully opaque
                    .overlay(
                        VStack {
                            Text("Question \(currentIndex + 1)")
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding(.bottom, 10)
                            Text(questions[currentIndex])
                                .font(.title3)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                    )
                    .padding(30)
                    .offset(x: offset.width, y: 0)
                    .rotationEffect(.degrees(Double(offset.width / 30)))
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                offset = gesture.translation
                            }
                            .onEnded { _ in
                                if abs(offset.width) > 100 {
                                    withAnimation {
                                        offset = CGSize(width: offset.width > 0 ? 1000 : -1000, height: 0)
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        offset = .zero
                                        if currentIndex < questions.count - 1 {
                                            currentIndex += 1
                                        }
                                    }
                                } else {
                                    // Card is not swiped, reset offset
                                    withAnimation {
                                        offset = .zero
                                    }
                                }
                            }
                    )
                    .zIndex(1)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
} 
