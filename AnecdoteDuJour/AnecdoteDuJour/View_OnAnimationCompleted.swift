//
//  View_OnAnimationCompleted.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 16/01/2023.
//

import Foundation
import SwiftUI

extension View {
/// Calls the completion handler whenever an animation on the given value completes.
/// - Parameters:
///   - value: The value to observe for animations.
///   - completion: The completion callback to call once the animation completes.
/// - Returns: A modified `View` instance with the observer attached.
    func onAnimationCompleted<Value: VectorArithmetic>(for value: Value, valueWithoutCompletion: Value, completion: @escaping () -> Void) -> ModifiedContent<Self, AnimationCompletionObserverModifier<Value>> {
    return modifier(AnimationCompletionObserverModifier(observedValue: value, valueWithoutCompletion: valueWithoutCompletion, completion: completion))
}
}
