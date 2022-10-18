//
//  AnimationCompletionObserverModifier.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 04/07/2022.
//

import Foundation
import SwiftUI

struct AnimationCompletionObserverModifier<Value>: AnimatableModifier where Value: VectorArithmetic {

    /// While animating, SwiftUI changes the old input value to the new target value using this property. This value is set to the old value until the animation completes.
    var animatableData: Value {
        didSet {
            notifyCompletionIfFinished()
        }
    }

    /// The target value for which we're observing. This value is directly set once the animation starts. During animation, `animatableData` will hold the oldValue and is only updated to the target value once the animation completes.
    private var targetValue: Value
    
    // on détermine la valeur initiale pour que la closure ne s'exécute pas lorsque l'animation revient à son état initial (ainsi, la closure s'exécute lors de la fin de la première animation
    private var valueWithoutCompletion: Value

    /// The completion callback which is called once the animation completes.
    private var completion: () -> Void

    init(observedValue: Value, valueWithoutCompletion: Value, completion: @escaping () -> Void) {
        self.completion = completion
        self.animatableData = observedValue
        self.valueWithoutCompletion = valueWithoutCompletion
        targetValue = observedValue
    }

    /// Verifies whether the current animation is finished and calls the completion callback if true.
    private func notifyCompletionIfFinished() {
        guard animatableData == targetValue && animatableData != valueWithoutCompletion else { return }

        /// Dispatching is needed to take the next runloop for the completion callback.
        /// This prevents errors like "Modifying state during view update, this will cause undefined behavior."
        DispatchQueue.main.async {
            self.completion()
        }
    }

    func body(content: Content) -> some View {
        /// We're not really modifying the view so we can directly return the original input value.
        return content
    }
}
