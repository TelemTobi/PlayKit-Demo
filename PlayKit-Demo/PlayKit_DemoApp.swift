//
//  PlayKit_DemoApp.swift
//  PlayKit-Demo
//
//  Created by Telem Tobi on 15/12/2025.
//

import SwiftUI
import AVKit

@main
struct PlayKit_DemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    try? AVAudioSession.sharedInstance().setCategory(.playback)
                }
        }
    }
}
