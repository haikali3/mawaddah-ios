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
    let tabs = ["Questions", "Statistics", "AI Analysis"]
    let questions = ["Q1", "Q2", "Q3", "Q4", "Q5", "Q6", "Q7", "Q8", "Q9", "Q10"]

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
                            .cornerRadius(10)
                            .foregroundColor(.black)
                            .font(.headline)
                    }
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.3)))
            .padding(.horizontal)

            // Question Picker
            Button(action: {
                showQuestionPicker = true
            }) {
                Text("Q\(selectedQuestion + 1)")
                    .frame(width: 100, height: 60)
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(10)
            }
            .sheet(isPresented: $showQuestionPicker) {
                VStack {
                    Picker("Select Question", selection: $selectedQuestion) {
                        ForEach(0..<questions.count, id: \.self) { index in
                            Text("Q\(index + 1)").tag(index)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .labelsHidden()
                    .frame(height: 200)
                    Button("Done") {
                        showQuestionPicker = false
                    }
                    .padding()
                }
            }

            // Flash Card Area
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white.opacity(0.3))
                .overlay(
                    Text("Flash Card")
                        .font(.title)
                        .foregroundColor(.black)
                )
                .padding(30) // Increased padding from default to 30
            // Spacer()
        }
        .background(Color.purple.opacity(0.3).ignoresSafeArea())
    }
}

#Preview {
    ContentView()
}
