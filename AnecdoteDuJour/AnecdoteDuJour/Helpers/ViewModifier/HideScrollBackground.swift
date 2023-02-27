//
//  HideScrollBackground.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 13/02/2023.
//

import SwiftUI

struct HideScrollBackground: ViewModifier {
    
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content.scrollContentBackground(.hidden)
        } else {
            content.background(Color("background"))
        }
    }
}

extension View {
    
    func hideScrollBackground() -> some View {
        modifier(HideScrollBackground())
    }
    
}


