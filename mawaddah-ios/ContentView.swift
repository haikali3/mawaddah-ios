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
    @State private var questions: [String] = Questions.allQuestions
    
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
    }
}

#Preview {
    ContentView()
}
