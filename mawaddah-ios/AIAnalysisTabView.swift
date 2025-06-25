import SwiftUI

struct AIAnalysisTabView: View {
    @StateObject private var viewModel: AIAnalysisViewModel

    init(personStore: PersonStore, questions: [Question]) {
        _viewModel = StateObject(wrappedValue: AIAnalysisViewModel(personStore: personStore, questions: questions))
    }

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            VStack {
                if viewModel.isLoading {
                    ProgressView("Analyzing...")
                } else {
                    ScrollView {
                        Text(viewModel.analysis)
                            .padding()
                    }
                }

                Button(action: {
                    viewModel.generateAnalysis()
                }) {
                    Text("Generate Analysis")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(QuestionColors.borderColour)
                        .cornerRadius(10)
                }
                .padding()
            }
            .onAppear {
                if viewModel.analysis.isEmpty {
                    viewModel.generateAnalysis()
                }
            }
        }
    }
}
