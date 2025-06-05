//
//  ContentView.swift
//  mawaddah-ios
//
//  Created by Haikal Tahar on 21/05/2025.
//

import SwiftUI

struct ContentView: View {
  @State private var selectedTab = 0
  @StateObject private var questionDeckViewModel = QuestionDeckViewModel()
  var body: some View {
    TabView(selection: $selectedTab) {
      QuestionsTabView(viewModel: questionDeckViewModel)
        .tabItem {
          Image(systemName: "questionmark.circle")
          Text("Questions")
        }
        .tag(0)

      PersonsTabView()
        .tabItem {
          Image(systemName: "person.circle")
          Text("Persons")
        }
        .tag(1)

      StatisticsTabView()
        .tabItem {
          Image(systemName: "chart.bar")
          Text("Statistics")
        }
        .tag(2)

      AIAnalysisTabView()
        .tabItem {
          Image(systemName: "brain.head.profile")
          Text("AI Analysis")
        }
        .tag(3)
    }
    .tint(QuestionColors.borderColour)
  }
}

#Preview {
  ContentView()
    .environmentObject(PersonStore())
}
