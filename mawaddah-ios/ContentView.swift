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
        }
        .tag(0)

      PersonsTabView()
        .tabItem {
          Image(systemName: "person.circle")
        }
        .tag(1)

      StatisticsTabView()
        .tabItem {
          Image(systemName: "chart.bar")
        }
        .tag(2)

      AIAnalysisTabView()
        .tabItem {
          Image(systemName: "brain.head.profile")
        }
        .tag(3)
    }
  }
}

#Preview {
  ContentView()
    .environmentObject(PersonStore())
}
