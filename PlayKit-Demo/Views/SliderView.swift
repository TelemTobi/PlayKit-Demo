//
//  SliderView.swift
//  Tryout
//
//  Created by Telem Tobi on 13/12/2025.
//

import SwiftUI

public struct SliderView: View {
    let range: ClosedRange<Double>
    @Binding var value: Double
    @Binding var isScrubbing: Bool
    @Binding var isInteractive: Bool
    let onValueCommitted: ((Double) -> Void)?
    let onScrubbingEnd: (() -> Void)?
    
    @State private var initialValue: Double = .zero
    @State private var isDebouncing: Bool = false
    
    private var progressInRange: Double {
        let value = isScrubbing ? initialValue : value
        let progress = value / (range.upperBound - range.lowerBound)
        if progress.isNaN || progress.isInfinite { return .zero }
        return progress
    }
    
    private var scrubProgressInRange: Double {
        value / (range.upperBound - range.lowerBound)
    }
    
    public init(range: ClosedRange<Double> = 0...1,
                value: Binding<Double>,
                isScrubbing: Binding<Bool>,
                isInteractive: Binding<Bool>,
                onValueCommitted: ((Double) -> Void)? = nil,
                onScrubbingEnd: (() -> Void)? = nil) {
        self.range = range
        self._value = value
        self._isScrubbing = isScrubbing
        self._isInteractive = isInteractive
        self.onValueCommitted = onValueCommitted
        self.onScrubbingEnd = onScrubbingEnd
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let height: CGFloat = 1
            let trackHeight = isScrubbing ? min(4, height * 4) : height
            let thumbSize = min(12, trackHeight * 4)
            
            ZStack(alignment: .leading) {
                Color.secondary.opacity(0.5)
                
                Color.primary
                    .frame(width: geometry.size.width * progressInRange)
                    .clipShape(.capsule)
                    .animation(.smooth, value: progressInRange)
            }
            .frame(height: trackHeight)
            .clipShape(.capsule)
            .overlay {
                if isInteractive {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: thumbSize, height: thumbSize)
                        .position(x: geometry.size.width * scrubProgressInRange, y: trackHeight / 2)
                }
            }
            .animation(.smooth, value: value)
            .animation(.snappy, value: trackHeight)
            .padding(.vertical, 12)
            .offset(y: isScrubbing ? -trackHeight / 2 : 0)
            .animation(.smooth, value: isScrubbing)
            .contentShape(.rect)
            .allowsHitTesting(isInteractive)
            .gesture(
                DragGesture(minimumDistance: .zero)
                    .onChanged { gesture in
                        if !isScrubbing {
                            isScrubbing = true
                            initialValue = value
                        }
                        
                        let dragOffset = gesture.translation.width / geometry.size.width
                        let delta = dragOffset * (range.upperBound - range.lowerBound)
                        value = (initialValue + delta).clamped(to: range)

                        guard !isDebouncing else { return }

                        Task { @MainActor in
                            isDebouncing = true
                            try? await Task.sleep(for: .seconds(0.1))
                            onValueCommitted?(value)
                            isDebouncing = false
                        }
                    }
                    .onEnded { gesture in
                        isScrubbing = false
                        onScrubbingEnd?()
                    }
            )
        }
    }
}

#Preview {
    @Previewable @State var progress: Double = 0
    @Previewable @State var isScrubbing: Bool = false
    @Previewable @State var isInteractive: Bool = false
    
    SliderView(
        range: 0...1,
        value: $progress,
        isScrubbing: $isScrubbing,
        isInteractive: $isInteractive
    )
    .frame(height: 4)
    .frame(maxWidth: .infinity)
    .preferredColorScheme(.dark)
}
