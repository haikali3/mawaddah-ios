//
//  ContentView.swift
//  mawaddah-ios
//
//  Created by Haikal Tahar on 21/05/2025.
//

import SwiftUI

struct ContentView: View {
  @State private var selectedTab = 2

  var body: some View {
    TabView(selection: $selectedTab) {
      QuestionsTabView()
        .tabItem {
          Image(systemName: "questionmark.circle")
          Text("Questions")
        }
        .tag(0)

      PartnersTabView()
        .tabItem {
          Image(systemName: "person.circle")
          Text("Partners")
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
}
