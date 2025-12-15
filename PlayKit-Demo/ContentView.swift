//
//  ContentView.swift
//  Tryout
//
//  Created by Telem Tobi on 13/12/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: TabType = .stories
    @State private var videoUrls: [URL] = []
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(TabType.allCases, id: \.self) { tab in
                Tab(tab.title, systemImage: tab.image, value: tab) {
                    Group {
                        switch tab {
                        case .stories:
                            StoriesView()
                            
                        case .reels:
                            ReelsView()
                        }
                    }
                    .environment(\.isFocused, selectedTab == tab)
                    .environment(\.videoUrls, videoUrls)
                }
            }
        }
        .onFirstAppear {
            decodeVideoUrls()
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

extension ContentView {
    enum TabType: Hashable, CaseIterable {
        case stories, reels
        
        var title: String {
            String(describing: self).capitalized
        }
        
        var image: String {
            switch self {
            case .stories: "square.stack.3d.down.forward"
            case .reels: "square.stack"
            }
        }
    }
}

#Preview {
    ContentView()
}
