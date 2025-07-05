//
//  IslamicGuidanceTabView.swift
//  mawaddah-ios
//
//  Created by Haikal Tahar on 05/07/2025.
//

import SwiftUI

struct IslamicGuidanceTabView: View {
    @StateObject private var guidanceRepository = IslamicGuidanceRepository()
    @State private var selectedCategory: IslamicGuidance.GuidanceCategory = .marriage
    @State private var searchText = ""
    @State private var showingSearch = false
    @State private var selectedGuidance: IslamicGuidance?
    @State private var isEnglish = true
    
    var filteredGuidances: [IslamicGuidance] {
        if showingSearch && !searchText.isEmpty {
            return guidanceRepository.searchGuidances(query: searchText)
        } else {
            return guidanceRepository.guidancesByCategory(selectedCategory)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Category picker
                if !showingSearch {
                    categoryPicker
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                }
                
                // Search bar
                if showingSearch {
                    searchBar
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                }
                
                // Guidance list
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredGuidances) { guidance in
                            GuidanceCardView(guidance: guidance, isEnglish: isEnglish)
                                .onTapGesture {
                                    selectedGuidance = guidance
                                }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .navigationTitle("Islamic Guidance")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        // Language toggle
                        Button(action: {
                            isEnglish.toggle()
                        }) {
                            Text(isEnglish ? "BM" : "EN")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .frame(width: 32, height: 24)
                                .background(QuestionColors.borderColour)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                        
                        // Search toggle
                        Button(action: {
                            showingSearch.toggle()
                            if !showingSearch {
                                searchText = ""
                            }
                        }) {
                            Image(systemName: showingSearch ? "xmark" : "magnifyingglass")
                                .foregroundColor(QuestionColors.borderColour)
                        }
                    }
                }
            }
        }
        .sheet(item: $selectedGuidance) { guidance in
            GuidanceDetailView(guidance: guidance, isEnglish: isEnglish)
        }
    }
    
    private var categoryPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(IslamicGuidance.GuidanceCategory.allCases, id: \.self) { category in
                    CategoryChip(
                        category: category,
                        isSelected: selectedCategory == category,
                        action: { selectedCategory = category }
                    )
                }
            }
            .padding(.horizontal, 4)
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search guidance...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

struct CategoryChip: View {
    let category: IslamicGuidance.GuidanceCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: category.icon)
                    .font(.caption)
                Text(category.displayName)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundColor(isSelected ? .white : QuestionColors.borderColour)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? QuestionColors.borderColour : Color.clear)
                    .stroke(QuestionColors.borderColour, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct GuidanceCardView: View {
    let guidance: IslamicGuidance
    let isEnglish: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(isEnglish ? guidance.title : guidance.titleMalay)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 8) {
                        // Source type badge
                        if guidance.isQuran {
                            sourceBadge(text: "Quran", color: .green)
                        } else if guidance.isHadith {
                            sourceBadge(text: "Hadith", color: .blue)
                        }
                        
                        // Category badge
                        sourceBadge(text: guidance.category.displayName, color: .orange)
                    }
                }
                
                Spacer()
                
                Image(systemName: guidance.category.icon)
                    .font(.title2)
                    .foregroundColor(QuestionColors.borderColour)
            }
            
            // Content preview
            Text(isEnglish ? guidance.content : guidance.contentMalay)
                .font(.body)
                .lineLimit(3)
                .foregroundColor(.secondary)
            
            // Reference
            Text(guidance.reference)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(QuestionColors.borderColour)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
    
    private func sourceBadge(text: String, color: Color) -> some View {
        Text(text)
            .font(.caption2)
            .fontWeight(.medium)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

struct GuidanceDetailView: View {
    let guidance: IslamicGuidance
    let isEnglish: Bool
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text(isEnglish ? guidance.title : guidance.titleMalay)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        HStack(spacing: 8) {
                            if guidance.isQuran {
                                sourceBadge(text: "Quran", color: .green)
                            } else if guidance.isHadith {
                                sourceBadge(text: "Hadith", color: .blue)
                            }
                            
                            sourceBadge(text: guidance.category.displayName, color: .orange)
                        }
                    }
                    
                    Divider()
                    
                    // Content
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Content")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text(isEnglish ? guidance.content : guidance.contentMalay)
                            .font(.body)
                            .lineSpacing(2)
                    }
                    
                    Divider()
                    
                    // Source and Reference
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Source")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text(isEnglish ? guidance.source : guidance.sourceMalay)
                            .font(.body)
                            .fontWeight(.medium)
                        
                        Text(guidance.reference)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    // Tags
                    if !guidance.tags.isEmpty {
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Tags")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            FlowLayout(spacing: 8) {
                                ForEach(guidance.tags, id: \.self) { tag in
                                    Text(tag)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundColor(.secondary)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color(.systemGray6))
                                        )
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Guidance")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func sourceBadge(text: String, color: Color) -> some View {
        Text(text)
            .font(.caption2)
            .fontWeight(.medium)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

// Simple FlowLayout for tags
struct FlowLayout: Layout {
    let spacing: CGFloat
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        return layout(sizes: sizes, proposal: proposal).size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let offsets = layout(sizes: sizes, proposal: proposal).offsets
        
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(
                x: bounds.minX + offsets[index].x,
                y: bounds.minY + offsets[index].y
            ), proposal: .unspecified)
        }
    }
    
    private func layout(sizes: [CGSize], proposal: ProposedViewSize) -> (offsets: [CGPoint], size: CGSize) {
        var offsets: [CGPoint] = []
        var currentPosition = CGPoint.zero
        var lineHeight: CGFloat = 0
        var maxWidth: CGFloat = 0
        
        let proposedWidth = proposal.width ?? .infinity
        
        for size in sizes {
            if currentPosition.x + size.width > proposedWidth && currentPosition.x > 0 {
                currentPosition.x = 0
                currentPosition.y += lineHeight + spacing
                lineHeight = 0
            }
            
            offsets.append(currentPosition)
            currentPosition.x += size.width + spacing
            lineHeight = max(lineHeight, size.height)
            maxWidth = max(maxWidth, currentPosition.x - spacing)
        }
        
        return (offsets, CGSize(width: maxWidth, height: currentPosition.y + lineHeight))
    }
}

#Preview {
    IslamicGuidanceTabView()
}