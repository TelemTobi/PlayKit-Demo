//
//  StoriesView.swift
//  Tryout
//
//  Created by Telem Tobi on 04/11/2025.
//

import SwiftUI
import PlayKit

struct StoriesView: View {
    @State var viewModel = StoriesViewModel()
    @Environment(\.isFocused) private var isFocused: Bool
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: .zero) {
                ForEach(Array(viewModel.storyViewModels.enumerated()), id: \.offset) { _, storyViewModel in
                    StoryView(viewModel: storyViewModel)
                        .containerRelativeFrame(.horizontal)
                        .scrollTransition(.interactive, axis: .horizontal) { view, phase in
                            view
                                .scaleEffect(phase.isIdentity ? 1 : 0.75)
                                .opacity(phase.isIdentity ? 1 : 0.8)
                        }
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .scrollIndicators(.hidden)
        .scrollPosition(id: $viewModel.scrollPosition)
        .onChange(of: viewModel.scrollPosition ?? .zero) { oldValue, newValue in
            viewModel.onScrollPositionChanged(oldValue, newValue)
        }
        .onChange(of: isFocused) { _, newValue in
            viewModel.onFocusChanged(newValue)
        }
        .onFirstAppear {
            viewModel.onFirstAppear()
        }
    }
}

#Preview {
    StoriesView(viewModel: StoriesViewModel())
}
