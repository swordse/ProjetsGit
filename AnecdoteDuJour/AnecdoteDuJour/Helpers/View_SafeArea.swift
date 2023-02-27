//
//  View_SafeArea.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 17/01/2023.
//

import SwiftUI

extension View {
    func safeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .zero}
        guard let safeArea = screen.windows.first?.safeAreaInsets else { return .zero }
        return safeArea
    }
}
