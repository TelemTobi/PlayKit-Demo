//
//  StoriesView.swift
//  Tryout
//
//  Created by Telem Tobi on 04/11/2025.
//

import SwiftUI
import PlayKit

struct StoriesView: View {
    @State private var scrollPosition: Int? = 0
    @State private var controllers: [PlaylistController] = []
    
    @Environment(\.isFocused) private var isFocused: Bool
    @Environment(\.videoUrls) private var videoUrls: [URL]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: .zero) {
                ForEach(Array(controllers.enumerated()), id: \.offset) { _, controller in
                    StoryView(
                        controller: controller,
                        moveToPreviousStory: moveToPreviousStory,
                        advanceToNextStory: advanceToNextStory
                    )
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
        .scrollPosition(id: $scrollPosition)
        .onChange(of: scrollPosition ?? .zero) { oldValue, newValue in
            controllers[safe: oldValue]?.isFocused = false
            controllers[safe: newValue]?.isFocused = true
        }
        .onChange(of: isFocused) { _, newValue in
            controllers[safe: scrollPosition ?? .zero]?.isFocused = newValue
        }
        .onFirstAppear {
            initiateControllers()
        }
    }
    
    private func moveToPreviousStory() {
        let currentPosition = scrollPosition ?? .zero
        
        if currentPosition > 1 {
            withAnimation {
                scrollPosition = currentPosition - 1
            }
        }
    }
    
    private func advanceToNextStory() {
        let currentPosition = scrollPosition ?? .zero
        
        if currentPosition < 3 {
            withAnimation {
                scrollPosition = currentPosition + 1
            }
        }
    }
    
    private func initiateControllers() {
        var items: [PlaylistItem] = videoUrls.map { url in
            ["m3u8", "mp4"].contains(url.pathExtension) ? .video(url) : .image(url)
        }
        
        items.insert(.custom(duration: 5), at: 1)
        items.insert(.error(), at: 10)
        
        controllers = (0..<3).map { index in
            PlaylistController(
                items: items,
                initialIndex: .zero,
                isFocused: index == 0
            )
        }
    }
}

#Preview {
    StoriesView()
}
