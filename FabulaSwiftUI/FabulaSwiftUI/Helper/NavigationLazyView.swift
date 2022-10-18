//
//  NavigationLazyView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 26/07/2022.
//

import SwiftUI

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) { 
        self.build = build
    }
    var body: Content {
        build()
    }
}
