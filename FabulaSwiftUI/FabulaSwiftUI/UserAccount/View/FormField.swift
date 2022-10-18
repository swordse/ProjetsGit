//
//  NewAccountView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 22/06/2022.
//

import SwiftUI

enum DisplayImage: String {
    case lock = "lock"
    case email = "envelope"
    case userName = "person"
}

struct FormField: View {
    
    @Binding var text: String
    var isSecured: Bool
    var placeholderString: String
    var imageToDisplay: DisplayImage
    var textContentType: UITextContentType
    var keyboardType: UIKeyboardType
    
    var body: some View {
        VStack {
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Image(systemName: imageToDisplay.rawValue)
                    .font(.system(size: 18, weight: .regular, design: .default))
                    .foregroundColor(.white).opacity(1)
                    .padding(.trailing, 5)
                SuperTextField(isSecured: isSecured, placeholder: Text(placeholderString)
                    .font(.system(size: 18, weight: .regular, design: .default)), textContentType: textContentType, keyboardType: keyboardType, text: $text)
                .foregroundColor(.white)
                .opacity(0.8)
            }
            Rectangle()
                .frame(height: 0.5)
                .background(Color.white)
                .opacity(0.4)
                .padding(.top, 5)
        }
    }
}

struct FormField_Previews: PreviewProvider {
    static var previews: some View {
        FormField(text: .constant(""), isSecured: false, placeholderString: "placeholder", imageToDisplay: DisplayImage.email, textContentType: .name, keyboardType: .emailAddress)
    }
}
