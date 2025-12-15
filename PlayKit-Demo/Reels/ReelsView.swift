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
            ZStack(alignment: .bottom) {
                PlaylistView(
                    type: .verticalFeed,
                    controller: playlistController,
                    overlayForItemAtIndex: { index in
                        ReelOverlayView(
                            index: index,
                            playlistController: playlistController
                        )
                        .offset(y: -geometry.safeAreaInsets.bottom)
                    }
                )
                .ignoresSafeArea(edges: .all)
                .onChange(of: isFocused) { _, newValue in
                    playlistController.isFocused = newValue
                }
            }
        }
        .onFirstAppear {
            initiateController()
        }
    }
    
    private func initiateController() {
        let items: [PlaylistItem] = videoUrls.map { url in
            ["m3u8", "mp4"].contains(url.pathExtension) ? .video(url) : .image(url)
        }
        
        playlistController.setItems(items)
    }
}

#Preview {
    ReelsView()
}
