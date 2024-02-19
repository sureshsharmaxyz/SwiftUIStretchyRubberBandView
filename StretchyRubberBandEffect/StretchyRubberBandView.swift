//
//  StretchyRubberBandView.swift
//  StretchyRubberBandEffect
//
//  Created by Suresh Sharma on 19/02/2024.
//

import SwiftUI

struct StretchyRubberBandView: View {

    @State private var dragOffset: CGSize = .zero
    @State private var stretchScale: CGSize = .init(width: 1, height: 1)
    @State private var isDragging = false

    let maxDragOffset: CGFloat = 120

    var body: some View {
            Circle()
                .fill(.blue)
                .frame( width: 80, height: 80)
                .gesture(dragGesture)
                .offset(dragOffset)
                .scaleEffect(x: stretchScale.width, y: stretchScale.height)
                .sensoryFeedback(.impact(flexibility: .soft, intensity: stretchFeedbackIntensity), trigger: dragOffset)
                .sensoryFeedback(.success, trigger: isDragging) { _, newValue in
                    newValue == false
                }
    }

    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                isDragging = true

                let clampedTranslation = limitMaxDistance(of: value.translation, to: maxDragOffset)

                withAnimation(.interactiveSpring) {
                    dragOffset = clampedTranslation

                    // stretch width
                    let absTranslationWidth = abs(value.translation.width)
                    stretchScale.width = map(value: absTranslationWidth, fromMin: 0, fromMax: 250, toMin: 1, toMax: 1.3)

                    // stretch height
                    let absTranslationHeight = abs(value.translation.height)
                    stretchScale.height = map(value: absTranslationHeight, fromMin: 0, fromMax: 250, toMin: 1, toMax: 1.3)
                }
            }
            .onEnded { value in
                isDragging = false
                withAnimation(.spring(response: 0.3, dampingFraction: 0.4)) {
                    dragOffset = .zero
                    stretchScale = .init(width: 1, height: 1)
                }
            }
    }

    func limitMaxDistance(of value: CGSize, to maxDistance: CGFloat) -> CGSize {
        // Length of the drag, ie, distance between value and centre
        let distance = hypot(value.width, value.height)

        // Check if the distance is greater than maxDistance, if not, return the original value
        guard distance > maxDistance else { return value }


        // Calculate the ratio to scale down the distance to maxDistance
        let ratio = maxDistance / distance

        // Scale down the width and height proportionally to maintain the aspect ratio
        let scaledWidth = (value.width) * ratio
        let scaledHeight = (value.height) * ratio

        // Return the new CGSize with scaled width and height
        return CGSize(width: scaledWidth, height: scaledHeight)
    }

    var stretchFeedbackIntensity: CGFloat {
        map(value: magnitude(of: stretchScale), fromMin: 1.4, fromMax: 1.7, toMin: 0.25, toMax: 0.75)
    }

    func map(value: CGFloat, fromMin: CGFloat, fromMax: CGFloat, toMin: CGFloat, toMax: CGFloat) -> CGFloat {
        let percentage = (value - fromMin) / (fromMax - fromMin)
        let mappedValue = percentage * (toMax - toMin) + toMin
        return mappedValue
    }

    func magnitude(of size: CGSize) -> CGFloat {
        return sqrt(pow(size.width, 2) + pow(size.height, 2))
    }

}


#Preview {
    StretchyRubberBandView()
}
