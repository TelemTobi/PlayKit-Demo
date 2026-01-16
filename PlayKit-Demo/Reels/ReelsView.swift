//
//  ReelsView.swift
//  Tryout
//
//  Created by Telem Tobi on 13/12/2025.
//

import SwiftUI
import PlayKit

struct ReelsView: View {
    @StateObject private var playlistController: PlaylistController
    
    @Environment(\.isFocused) private var isFocused: Bool
    @Environment(\.videoUrls) private var videoUrls: [URL]
    
    init() {
        self._playlistController = StateObject(
            wrappedValue: PlaylistController(
                items: [],
                isFocused: true
            )
        )
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                PlaylistView(
                    type: .verticalFeed,
                    controller: playlistController,
                    overlayForItemAtIndex: { index in
                        ReelOverlayView(
                            index: index,
                            playlistController: playlistController,
                        )
                        .offset(y: -geometry.safeAreaInsets.bottom)
                    }
                )
                .ignoresSafeArea(edges: .all)
                .onChange(of: isFocused) { _, newValue in
                    playlistController.isFocused = newValue
                }
                
                if !playlistController.isPlaying, !playlistController.items.isEmpty {
                    Image(systemName: "play.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .offset(x: 2)
                        .padding()
                        .transition(.blurReplace.animation(.snappy(duration: 0.1)))
                        .glassEffect(.regular.interactive(), in: .circle)
                }
            }
            .contentShape(.rect)
            .onTapGesture {
                playlistController.isPlaying.toggle()
            }
        }
        .onFirstAppear {
            initiateController()
        }
    }
    
    private func initiateController() {
        var items: [PlaylistItem] = videoUrls.map { url in
            ["m3u8", "mp4"].contains(url.pathExtension) ? .video(id: url.absoluteString, url) : .image(url)
        }
        
        items.append(.custom(id: 5, duration: 5))
        playlistController.setItems(items)
    }
}

#Preview {
    ReelsView()
}
