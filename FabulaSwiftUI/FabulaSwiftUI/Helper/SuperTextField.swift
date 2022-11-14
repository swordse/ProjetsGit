//
//  SuperTextField.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 22/06/2022.
//

import Foundation
import SwiftUI

struct SuperTextField: View {
    
    @State private var isHidden = true
    var isLightBlue = false
    var isSecured: Bool
    var placeholder: Text
    var textContentType: UITextContentType
    var keyboardType: UIKeyboardType
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if isLightBlue {
                Color.lightBackground
                    .cornerRadius(10)
                    .frame(height: 40)
                
            }
            if text.isEmpty { placeholder }
            if isSecured {
                if isHidden {
                    SecureField("", text: $text, onCommit: commit)
                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                        .textContentType(.password)
                        .autocapitalization(.none)
                        .keyboardType(keyboardType)
                        .disableAutocorrection(true)
                        .padding(.leading, 10)
                } else {
                    TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
                        .textContentType(textContentType)
                        .autocapitalization(.none)
                        .keyboardType(keyboardType)
                        .disableAutocorrection(true)
                        .padding(.leading, 10)
                }
                HStack {
                    Spacer()
                    Button {
                        isHidden.toggle()
                    } label: {
                        Image(systemName: isHidden ? "eye" : "eye.slash")
                    }
                }
            } else {
                TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
                    .textContentType(textContentType)
                    .autocapitalization(.none)
                    .keyboardType(keyboardType)
                    .disableAutocorrection(true)
                    .padding(.leading, 10)
            }
        }
    }
    
}
