//
//  View+HideKeyboard.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 24/06/2022.
//

import Foundation
import SwiftUI

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
