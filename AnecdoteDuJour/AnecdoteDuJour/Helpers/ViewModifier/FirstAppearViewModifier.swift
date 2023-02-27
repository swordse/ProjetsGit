//
//  FirstAppearViewModifier.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 10/02/2023.
//

import SwiftUI

private struct FirstAppearViewModifier: ViewModifier {
    
    let action: () -> ()
    @State private var hasAppeared = false
    
    func body(content: Content) -> some View {
        content.onAppear {
            guard !hasAppeared else { return }
            hasAppeared = true
            action()
        }
    }
}

public extension View {
    func onFirstAppear(action: @escaping () -> ()) -> some View {
        modifier(FirstAppearViewModifier(action: action))
    }
}

