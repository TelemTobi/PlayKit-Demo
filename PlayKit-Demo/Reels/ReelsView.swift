//
//  ReelsView.swift
//  Tryout
//
//  Created by Telem Tobi on 13/12/2025.
//

import SwiftUI
import PlayKit

struct ReelsView: View {
    @State var viewModel = ReelsViewModel()
    @Environment(\.isFocused) private var isFocused: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                PlaylistView(
                    type: .verticalFeed,
                    controller: viewModel.playlistController,
                    overlayForItemAtIndex: { index in
                        ReelOverlayView(
                            index: index,
                            playlistController: viewModel.playlistController
                        )
                        .offset(y: -geometry.safeAreaInsets.bottom)
                    }
                )
                .ignoresSafeArea(edges: .all)
                
            }
        }
        .onChange(of: isFocused) { _, newValue in
            viewModel.onFocusChanged(newValue)
        }
    }
}

#Preview {
    ReelsView(viewModel: ReelsViewModel())
}
