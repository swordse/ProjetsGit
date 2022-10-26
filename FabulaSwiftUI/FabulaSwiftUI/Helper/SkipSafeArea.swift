//
//  SkipSafeArea.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 17/06/2022.
//

import SwiftUI

struct TextEditorBackGround: ViewModifier {
    
    func body(content: Content) -> some View {
        if #available(iOS 16, *) {
            content
                .hideScrollBackground()
                .background(Color.lightBackground)
        } else if #available(iOS 14.0, *) {
            content
                .onAppear {
                    UITextView.appearance().backgroundColor = .clear
                }
                .background(Color.lightBackground)
        }
    
    }
}

struct RefreshView: ViewModifier {
    
    var action: @Sendable () async -> Void
    
    func body(content: Content) -> some View {
        if #available(iOS 15, *) {
            content.refreshable(action: action)
        } else {
            content
        }
    }
}

struct HiddeRowSeparator: ViewModifier {
    
    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content
                .listRowSeparator(.hidden)
        }
        else if #available(iOS 14.0, *) {
            content
                .onAppear {
                    UITableView.appearance().separatorColor = UIColor(Color.background)
                }
        }
        else {
            content
                .onAppear() {
                    UITableView.appearance().separatorStyle = .none
                }
        }
    }
}

struct RowSeparatorColor: ViewModifier {
    
    var color: Color
    
    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content
                .listRowSeparatorTint(color)
        } else {
            content
                .onAppear() {
                    UITableView.appearance().separatorStyle = .none
                }
        }
    }
}

struct TintOrAccentColor: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content.tint(color)
        } else {
            content.accentColor(color)
        }
    }
    
    
}

struct HideScrollBackground: ViewModifier {
    
    func body(content: Content) -> some View {
            if #available(iOS 16.0, *) {
                content
                    .scrollContentBackground(.hidden)
            } else {
                content.background(Color.background)
            }
    }
}

extension View {

    
    func textEditorBackGround() -> some View {
        modifier(TextEditorBackGround())
    }
    
    func refreshView(action: @escaping @Sendable () async -> Void) -> some View {
        modifier(RefreshView(action: action))
    }
    
    func hideRowSeparator() -> some View {
        modifier(HiddeRowSeparator())
    }

    
    func rowSeparatorColor(color: Color) -> some View {
        modifier(RowSeparatorColor(color: color))
    }
    
    func hideScrollBackground() -> some View {
        modifier(HideScrollBackground())
    }
    
    func tintOrAccentColor(color: Color) -> some View {
        modifier(TintOrAccentColor(color: color))
    }
}
