//
//  ReelOverlayView.swift
//  Tryout
//
//  Created by Telem Tobi on 15/12/2025.
//

import SwiftUI
import PlayKit

struct ReelOverlayView: View {
    let index: Int
    @ObservedObject var playlistController: PlaylistController
    @State var isScrubbing: Bool = false
    
    @State private var progress: TimeInterval = .zero
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.clear
            
            VStack {
                Text(index.description)
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                
                HStack {
                    Text(playlistController.progressInSeconds.timeFormatted)
                    
                    Text("/")
                    
                    Text(playlistController.durationInSeconds.timeFormatted)
                }
                
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
            }
        }
        .padding()
        .bind(playlistController.progressInSeconds, to: $progress)
    }
}
