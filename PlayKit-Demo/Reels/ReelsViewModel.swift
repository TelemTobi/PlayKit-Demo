//
//  ReelsViewModel.swift
//  PlayKit-Demo
//
//  Created by Telem Tobi on 27/12/2025.
//

import Foundation
import PlayKit
import SwiftUI

@Observable
class ReelsViewModel {
    let playlistController: PlaylistController
    private var videoUrls: [URL] = []
    
    init() {
        playlistController = PlaylistController(items: [], isFocused: true)
        initiatePlaylistItems()
    }
    
    func onFocusChanged(_ newValue: Bool) {
        playlistController.isFocused = newValue
    }
    
    private func initiatePlaylistItems() {
        decodeVideoUrls()
        
        let items: [PlaylistItem] = videoUrls.map { url in
            ["m3u8", "mp4"].contains(url.pathExtension) ? .video(url) : .image(url)
        }
        
        playlistController.setItems(items)
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
