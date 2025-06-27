import SwiftUI

struct QuestionPickerButton: View {
  let questions: [Question]
  @Binding var currentIndex: Int
  @Binding var showQuestionPicker: Bool
  @State private var searchText = ""
  @State private var selectedTags = Set<String>()

  private var filteredQuestions: [Question] {
    questions.filtered(by: searchText, tags: selectedTags)
  }
  private var allTags: [String] {
    questions.uniqueTags()
  }

  private var currentQuestion: Question? {
    guard currentIndex >= 0 && currentIndex < questions.count else { return nil }
    return questions[currentIndex]
  }

  var body: some View {
    Button {
      showQuestionPicker = true
    } label: {
      ZStack {
        RoundedRectangle(cornerRadius: 30)
          .fill(QuestionColors.cardColour)
          .overlay(
            RoundedRectangle(cornerRadius: 30)
              .stroke(QuestionColors.borderColour, lineWidth: 2)
          )
        Text("Question \(currentIndex + 1) of \(questions.count)")
          .font(.headline)
          .foregroundColor(QuestionColors.borderColour)
      }
      .frame(width: 300, height: 50)
    }
    .sheet(isPresented: $showQuestionPicker) {
      NavigationStack {
        // Tag filter view
        if !allTags.isEmpty {
          HStack {
            // Sticky Clear Filters button
            Button(action: { selectedTags.removeAll() }) {
              Image(systemName: "xmark.circle.fill")
                .font(.system(size: 20))
                .foregroundColor(QuestionColors.borderColour)
            }

            ScrollView(.horizontal, showsIndicators: false) {
              HStack(spacing: 8) {
                ForEach(allTags, id: \.self) { tag in
                  TagView(
                    tag: tag,
                    isSelected: selectedTags.contains(tag),
                    action: {
                      if selectedTags.contains(tag) {
                        selectedTags.remove(tag)
                      } else {
                        selectedTags.insert(tag)
                      }
                    }
                  )
                }
              }
              .padding(.vertical, 8)
              .padding(.leading, 8)
            }
          }
          .padding(.horizontal, 15)
        }
        List {
          ForEach(filteredQuestions) { question in
            Button {
              if let newIndex = questions.firstIndex(where: { $0.id == question.id }) {
                currentIndex = newIndex
              }
              showQuestionPicker = false
            } label: {
              HStack {
                Text("\(question.id).")
                  .foregroundColor(QuestionColors.borderColour)
                Text(question.text)
                  .foregroundColor(QuestionColors.borderColour)
                if question.id == currentQuestion?.id {
                  Image(systemName: "checkmark")
                    .foregroundColor(QuestionColors.borderColour)
                }
              }
            }
          }
        }
        .searchable(text: $searchText, prompt: "Search questions")
        .navigationTitle("Select Question")
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            Button("Done") { showQuestionPicker = false }
              .foregroundColor(QuestionColors.borderColour)
          }
        }
      }
    }
  }
}

// TagView: Reusable tag component
struct TagView: View {
  let tag: String
  let isSelected: Bool
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      Text(tag)
        .font(.caption)
        .padding(.vertical, 6)
        .padding(.horizontal, 12)
        .background(
          isSelected ? QuestionColors.borderColour : QuestionColors.cardColour
        )
        .foregroundColor(isSelected ? .white : QuestionColors.borderColour)
        .cornerRadius(12)
        .overlay(
          RoundedRectangle(cornerRadius: 12)
            .stroke(QuestionColors.borderColour, lineWidth: 1.5)
        )
    }
  }
}

#Preview {
  QuestionPickerButton(
    questions: QuestionRepository.loadAll(),
    currentIndex: .constant(0),
    showQuestionPicker: .constant(false)
  )
}
