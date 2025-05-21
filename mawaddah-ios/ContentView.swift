//
//  ContentView.swift
//  mawaddah-ios
//
//  Created by Haikal Tahar on 21/05/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var selectedQuestion = 0
    @State private var showQuestionPicker = false
    @State private var questions: [String] = []
    
    var body: some View {
        TabView(selection: $selectedTab) {
            QuestionsTabView(
                selectedQuestion: $selectedQuestion,
                showQuestionPicker: $showQuestionPicker,
                questions: questions
            )
            .tabItem {
                Image(systemName: "questionmark.circle")
                Text("Questions")
            }
            .tag(0)

            StatisticsTabView()
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Statistics")
                }
                .tag(1)

            AIAnalysisTabView()
                .tabItem {
                    Image(systemName: "brain.head.profile")
                    Text("AI Analysis")
                }
                .tag(2)
        }
        .onAppear {
            loadQuestions()
        }
    }
    
    private func loadQuestions() {
        if let path = Bundle.main.path(forResource: "questions-en", ofType: "txt") {
            do {
                let content = try String(contentsOfFile: path, encoding: .utf8)
                questions = content.components(separatedBy: .newlines)
                    .filter { !$0.isEmpty }
                    .map { $0.trimmingCharacters(in: .whitespaces) }
                print("Successfully loaded \(questions.count) questions")
            } catch {
                print("Error loading questions: \(error)")
                questions = ["Error loading questions"]
            }
        } else {
            print("Could not find questions-en.txt in bundle")
            questions = ["Error: Questions file not found"]
        }
    }
}

#Preview {
    ContentView()
}
