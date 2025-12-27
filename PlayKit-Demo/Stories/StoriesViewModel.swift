//
//  StoriesViewModel.swift
//  PlayKit-Demo
//
//  Created by Telem Tobi on 27/12/2025.
//

import Foundation
import PlayKit
import SwiftUI

@Observable
class StoriesViewModel {
    var storyViewModels: [StoryViewModel] = []
    var scrollPosition: Int? = .zero

    private var videoUrls: [URL] = []
    
    func onFirstAppear() {
        initiateStoryViewModels()
    }
    
    func onFocusChanged(_ newValue: Bool) {
        storyViewModels[safe: scrollPosition ?? .zero]?.isFocused = newValue
    }
    
    func onScrollPositionChanged(_ oldValue: Int, _ newValue: Int) {
        storyViewModels[safe: oldValue]?.isFocused = false
        storyViewModels[safe: newValue]?.isFocused = true
    }
    
    func moveToPreviousStory() {
        let currentPosition = scrollPosition ?? .zero
        
        if currentPosition > .zero {
            withAnimation(.snappy) {
                scrollPosition = currentPosition - 1
            }
        }
    }
    
    func advanceToNextStory() {
        let currentPosition = scrollPosition ?? .zero
        
        if currentPosition < 3 {
            withAnimation(.snappy){
                scrollPosition = currentPosition + 1
            }
        }
    }
    
    private func initiateStoryViewModels() {
        decodeVideoUrls()
        
        var items: [PlaylistItem] = videoUrls.map { url in
            ["m3u8", "mp4"].contains(url.pathExtension) ? .video(url) : .image(url)
        }
        
        items.insert(.custom(duration: 5), at: 1)
        items.insert(.error(), at: 10)
        
        storyViewModels = (0..<3)
            .map { index in
                PlaylistController(
                    items: items,
                    initialIndex: .zero,
                    isFocused: index == scrollPosition
                )
            }
            .map { controller in
                StoryViewModel(
                    playlistController: controller,
                    moveToPreviousStory: { [weak self] in self?.moveToPreviousStory() },
                    advanceToNextStory: { [weak self] in self?.advanceToNextStory() }
                )
            }
    }
    
    private func decodeVideoUrls() {
        guard let filePath = Bundle.main.path(forResource: "VideoUrls", ofType: "json") else {
            fatalError("File not found")
        }
        
        guard let string = try? String(contentsOfFile: filePath, encoding: .utf8) else {
            fatalError("File is invalid")
        }
        
        guard let urls = try? JSONDecoder().decode([String].self, from: Data(string.utf8)) else {
            fatalError("Decoding error")
        }
        
        videoUrls = urls.compactMap { URL(string: $0) }
    }
}
