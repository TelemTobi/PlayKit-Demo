//
//  OnFirstAppearModifier.swift
//  Tryout
//
//  Created by Telem Tobi on 04/11/2025.
//

import SwiftUI

fileprivate struct OnFirstAppearModifier: ViewModifier {
    let action: () -> Void
    @State private var isFirstTime: Bool = true
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if isFirstTime {
                    isFirstTime = false
                    action()
                }
            }
    }
}

public extension View {
    func onFirstAppear(perform action: @escaping () -> Void) -> some View {
        modifier(OnFirstAppearModifier(action: action))
    }
}
