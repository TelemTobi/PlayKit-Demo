//
//  StoryView.swift
//  Tryout
//
//  Created by Telem Tobi on 14/09/2025.
//

import Combine
import SwiftUI
import PlayKit

struct StoryView: View {
    let moveToPreviousStory: () -> Void
    let advanceToNextStory: () -> Void
    
    @ObservedObject private var playlistController: PlaylistController
    @State private var isScrubbing: Bool = false
    @State private var progress: TimeInterval = .zero
    
    init(
        controller: PlaylistController,
        moveToPreviousStory: @escaping () -> Void,
        advanceToNextStory: @escaping () -> Void
    ) {
        self.playlistController = controller
        self.moveToPreviousStory = moveToPreviousStory
        self.advanceToNextStory = advanceToNextStory
    }
    
    var body: some View {
        ZStack {
            PlaylistView(
                type: .tapThrough,
                controller: playlistController
            )
            
            if case .custom = playlistController.items[safe: playlistController.currentIndex] {
                Text("🐣\nCustom PlaylistItem")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
            }
            
            if playlistController.status == .loading {
                ProgressView()
                
            } else if playlistController.status == .error {
                ContentUnavailableView(
                    "Something went wrong",
                    systemImage: "exclamationmark.triangle"
                )
            }
            
            gesturesView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .gesture(longPressGeture())
        .overlay(alignment: .bottom) {
            overlayContent()
        }
        .bind(playlistController.progressInSeconds, to: $progress)
        .onChange(of: playlistController.currentIndex) { _, _ in
            progress = .zero
        }
        .onReceive(playlistController.reachedEnd) { _ in
            advanceToNextStory()
        }
    }
    
    @ViewBuilder
    private func overlayContent() -> some View {
        VStack(spacing: 16) {
            HStack {
                Button("⏪︎ 2") {
                    playlistController.setCurrentIndex(playlistController.currentIndex - 2)
                }
                .buttonStyle(.glass)
                
                Spacer()
                
                Text(playlistController.progressInSeconds.timeFormatted)
                
                Text("/")
                
                Text(playlistController.durationInSeconds.timeFormatted)
                
                Spacer()
                
                Button("2 ⏩︎") {
                    playlistController.setCurrentIndex(playlistController.currentIndex + 2)
                }
                .buttonStyle(.glass)
            }
            .font(.system(.title3))
            .foregroundStyle(.white)
            
            SliderView(
                range: 0...playlistController.durationInSeconds,
                value: $progress,
                isScrubbing: $isScrubbing,
                isInteractive: .constant(true),
                onValueCommitted: {
                    playlistController.setProgress($0)
                }
            )
            .frame(height: 28)
            
            HStack(spacing: 16) {
                Button {
                    playlistController.isPlaying ? playlistController.pause() : playlistController.play()
                } label: {
                    Image(systemName: playlistController.isPlaying ? "pause.fill" : "play.fill")
                        .imageScale(.large)
                }
                .buttonStyle(.glass)
                
                Spacer()
                
                Text("\(playlistController.currentIndex + 1)/\(playlistController.items.count)")
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
    
    @ViewBuilder
    private func gesturesView() -> some View {
        HStack(spacing: .zero) {
            Color.clear
                .frame(maxWidth: .infinity)
                .contentShape(.rect)
                .onTapGesture {
                    if playlistController.currentIndex == .zero {
                        moveToPreviousStory()
                    } else {
                        playlistController.moveToPrevious()
                    }
                }
            
            Color.clear
                .frame(maxWidth: .infinity)
                .contentShape(.rect)
                .onTapGesture {
                    if playlistController.currentIndex == playlistController.items.count - 1 {
                        advanceToNextStory()
                    } else {
                        playlistController.advanceToNext()
                    }
                }
        }
    }
    
    private func longPressGeture() -> some Gesture {
        LongPressGesture(minimumDuration: 0.25)
            .onEnded { isPressed in
                if isPressed {
//                    playlistController.pause()
                    playlistController.setRate(2)
                }
            }
            .sequenced(
                before: DragGesture(minimumDistance: .zero)
                    .onChanged { _ in
//                        playlistController.pause()
                        playlistController.setRate(2)
                    }
                    .onEnded { _ in
//                        playlistController.play()
                        playlistController.setRate(1)
                    }
            )
    }
}
