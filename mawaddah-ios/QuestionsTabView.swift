import SwiftUI

struct QuestionsTabView: View {
    @Binding var selectedQuestion: Int
    @Binding var showQuestionPicker: Bool
    let questions: [String]
    
    var body: some View {
        VStack {
            SwipableFlashCardView(currentIndex: $selectedQuestion, questions: questions)
            QuestionPickerButton(
                selectedQuestion: $selectedQuestion,
                showQuestionPicker: $showQuestionPicker,
                questions: questions
            )
            .frame(maxWidth: .infinity)
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
    @State private var ratings: [Int: Int] = [:] // questionIndex: rating

    // Centralized card color
    let cardColor = Color(red: 238/255, green: 219/255, blue: 248/255) // light purple
    let borderColor = Color(red: 80/255, green: 0/255, blue: 80/255) // dark purple

    var isDragging: Bool {
        offset.width != 0
    }

    var body: some View {
        ZStack {
            // Next card (only when dragging)
            if isDragging, currentIndex + 1 < questions.count {
                CardView(
                    questionNumber: currentIndex + 2,
                    questionText: questions[currentIndex + 1],
                    rating: .constant(ratings[currentIndex + 1] ?? 3),
                    isInteractive: false,
                    cardColor: cardColor,
                    borderColor: borderColor,
                    offset: .zero,
                    rotation: 0
                )
                .zIndex(0)
            }

            // Current card (always visible)
            if currentIndex < questions.count {
                CardView(
                    questionNumber: currentIndex + 1,
                    questionText: questions[currentIndex],
                    rating: Binding(
                        get: { ratings[currentIndex] ?? 3 },
                        set: { ratings[currentIndex] = $0 }
                    ),
                    isInteractive: true,
                    cardColor: cardColor,
                    borderColor: borderColor,
                    offset: CGSize(width: offset.width, height: 0),
                    rotation: Double(offset.width / 30)
                )
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
                                withAnimation {
                                    offset = .zero
                                }
                            }
                        }
                )
                .zIndex(1)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

struct CardView: View {
    let questionNumber: Int
    let questionText: String
    @Binding var rating: Int
    let isInteractive: Bool
    let cardColor: Color
    let borderColor: Color
    let offset: CGSize
    let rotation: Double

    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .fill(cardColor)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(borderColor, lineWidth: 2)
            )
            .overlay(
                VStack {
                    Text("Question \(questionNumber)")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.bottom, 10)
                    Text(questionText)
                        .font(.title3)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding()
                    VStack(spacing: 4) {
                        HeartRatingView(rating: $rating, isInteractive: isInteractive)
                            .padding(.bottom, 18)
                        Text("🤍 = Negative ❤️ = Positive")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 8)
                }
            )
            .padding(30)
            .offset(offset)
            .rotationEffect(.degrees(rotation))
    }
}

// Star rating view
struct HeartRatingView: View {
    @Binding var rating: Int
    var isInteractive: Bool = true

    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { heart in
                Text(heart <= rating ? "❤️" : "🤍")
                    .font(.system(size: 40))
                    .onTapGesture {
                        if isInteractive {
                            rating = heart
                        }
                    }
            }
        }
    }
} 
