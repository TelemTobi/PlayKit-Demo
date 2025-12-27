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
    let viewModel: StoryViewModel
    
    @State private var isScrubbing: Bool = false
    @State private var progress: TimeInterval = .zero
    
    init(viewModel: StoryViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            PlaylistView(
                type: .tapThrough,
                controller: viewModel.playlistController
            )
            
            if case .custom = viewModel.currentPlaylistItem {
                Text("🐣\nCustom PlaylistItem")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
            }
            
            if viewModel.playlistStatus == .loading {
                ProgressView()
                
            } else if viewModel.playlistStatus == .error {
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
        .bind(viewModel.playlistController.progressInSeconds, to: $progress)
        .onChange(of: viewModel.currentItemIndex) { _, _ in
            progress = .zero
        }
    }
    
    @ViewBuilder
    private func overlayContent() -> some View {
        VStack(spacing: 8) {
            HStack(spacing: 16) {
                Button {
                    viewModel.isPlaying.toggle()
                } label: {
                    Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                        .imageScale(.large)
                }
                .buttonStyle(.glass)
                
                Spacer()
                
                HStack {
                    Text(viewModel.playlistController.progressInSeconds.timeFormatted)
                    Text("/")
                    Text(viewModel.playlistController.durationInSeconds.timeFormatted)
                }
                .font(.system(.title3))
                .foregroundStyle(.white)
                
                Spacer()
                
                Text("\(viewModel.currentItemIndex + 1)/\(viewModel.playlistController.items.count)")
                    .foregroundStyle(.secondary)
            }
            
            SliderView(
                range: 0...viewModel.playlistController.durationInSeconds,
                value: $progress,
                isScrubbing: $isScrubbing,
                isInteractive: .constant(true),
                onValueCommitted: {
                    viewModel.playlistController.setProgress($0)
                }
            )
            .frame(height: 28)
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
                    viewModel.moveToPrevious()
                    
                }
            
            Color.clear
                .frame(maxWidth: .infinity)
                .contentShape(.rect)
                .onTapGesture {
                    viewModel.advanceToNext()
                }
        }
    }
    
    private func longPressGeture() -> some Gesture {
        LongPressGesture(minimumDuration: 0.25)
            .onEnded { isPressed in
                if isPressed {
//                    viewModel.playlistController.pause()
                    viewModel.playlistController.setRate(2)
                }
            }
            .sequenced(
                before: DragGesture(minimumDistance: .zero)
                    .onChanged { _ in
//                        viewModel.playlistController.pause()
                        viewModel.playlistController.setRate(2)
                    }
                    .onEnded { _ in
//                        viewModel.playlistController.play()
                        viewModel.playlistController.setRate(1)
                    }
            )
    }
}
