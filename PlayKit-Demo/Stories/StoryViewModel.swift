//
//  StoryViewModel.swift
//  PlayKit-Demo
//
//  Created by Telem Tobi on 27/12/2025.
//

import Foundation
import Combine
import PlayKit

@Observable
class StoryViewModel {
    let playlistController: PlaylistController
    
    private let moveToPreviousStory: () -> Void
    private let advanceToNextStory: () -> Void
    private var subscriptions: Set<AnyCancellable> = []
    
    var isFocused: Bool {
        get { playlistController.isFocused }
        set { playlistController.isFocused = newValue }
    }
    
    var isPlaying: Bool {
        get { playlistController.isPlaying }
        set { playlistController.isPlaying = newValue }
    }
    
    var currentItemIndex: Int {
        playlistController.currentIndex
    }

    var playlistStatus: PlaylistItem.Status {
        playlistController.status
    }
    
    var currentPlaylistItem: PlaylistItem? {
        playlistController.items[safe: playlistController.currentIndex]
    }
    
    init(
        playlistController: PlaylistController,
        moveToPreviousStory: @escaping () -> Void,
        advanceToNextStory: @escaping () -> Void
    ) {
        self.playlistController = playlistController
        self.moveToPreviousStory = moveToPreviousStory
        self.advanceToNextStory = advanceToNextStory
        
        registerSubscriptions()
    }
    
    private func registerSubscriptions() {
        playlistController.itemReachedEnd
            .sink { [weak self] in
                guard let self else { return }
                
                if playlistController.currentIndex == playlistController.items.count - 1 {
                    advanceToNextStory()
                }
            }
            .store(in: &subscriptions)
    }
    
    func moveToPrevious() {
        if playlistController.currentIndex == .zero {
            moveToPreviousStory()
        } else {
            playlistController.moveToPrevious()
        }
    }
    
    func advanceToNext() {
        if playlistController.currentIndex == playlistController.items.count - 1 {
            advanceToNextStory()
        } else {
            playlistController.advanceToNext()
        }
    }
}
