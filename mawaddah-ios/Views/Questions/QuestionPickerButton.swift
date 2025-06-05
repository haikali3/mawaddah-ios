import SwiftUI

struct QuestionPickerButton: View {
  @ObservedObject var viewModel: QuestionDeckViewModel
  @Binding var showQuestionPicker: Bool
  @State private var searchText = ""
  @State private var selectedTags = Set<String>()
  private var filteredQuestions: [Question] {
    viewModel.questions.filtered(by: searchText, tags: selectedTags)
  }
  private var allTags: [String] {
    viewModel.questions.uniqueTags()
  }

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
          .foregroundColor(borderColour)
      }
      .frame(width: 350, height: 50)
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
          .padding(.horizontal, 10)
        }
        List {
          ForEach(filteredQuestions) { question in
            Button {
              if let newIndex = viewModel.questions.firstIndex(where: { $0.id == question.id }) {
                viewModel.index = newIndex
              }
              showQuestionPicker = false
            } label: {
              HStack {
                Text("\(question.id).")
                  .foregroundColor(borderColour)
                Text(question.text)
                  .foregroundColor(borderColour)
                if question.id == viewModel.currentQuestion?.id {
                  Image(systemName: "checkmark")
                    .foregroundColor(borderColour)
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
              .foregroundColor(borderColour)
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
