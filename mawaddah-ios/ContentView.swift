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
    let tabs = ["Questions", "Statistics", "AI Analysis"]
    let questions = ["Q1", "Q2", "Q3"] // Replace with your questions

    var body: some View {
        VStack(spacing: 20) {
            // Top Navigation
            HStack(spacing: 20) {
                ForEach(Array(tabs.indices), id: \.self) { index in
                    Button(action: {
                        selectedTab = index
                    }) {
                        Text(tabs[index])
                            .frame(width: 100, height: 60)
                            .background(Color.white.opacity(0.7))
                            .cornerRadius(15)
                            .foregroundColor(.black)
                            .font(.headline)
                    }
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 25).fill(Color.white.opacity(0.3)))
            .padding(.horizontal)

            // Question Picker
            Picker("Question Picker", selection: $selectedQuestion) {
                ForEach(Array(questions.indices), id: \.self) { index in
                    Text(questions[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)

            // Flash Card Area
            Spacer()
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white.opacity(0.3))
                .overlay(
                    Text("Flash Card")
                        .font(.title)
                        .foregroundColor(.black)
                )
                .padding()
                .frame(maxHeight: .infinity)
            Spacer()
        }
        .background(Color.purple.opacity(0.3).ignoresSafeArea())
    }
}

#Preview {
    ContentView()
}
