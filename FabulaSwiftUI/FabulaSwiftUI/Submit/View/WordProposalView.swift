//
//  WordProposalView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 23/06/2022.
//

import SwiftUI

struct WordProposalView: View {
    
    @Binding var word: String
    @Binding var definition: String
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
        VStack(spacing: 10) {
            SubmitForm(image: ImageSubmitForm.word, categoryName: "Mot")
            
            SuperTextField(isLightBlue: true, isSecured: false, placeholder: Text("mot")
                .font(.system(size: 16, weight: .regular, design: .default)), textContentType: .name, keyboardType: .default
                           , text: $word)
            .foregroundColor(word.isEmpty ? .secondary : .white)
        }
            
        VStack(spacing: 10) {
            SubmitForm(image: ImageSubmitForm.text, categoryName: "Définition")

            TextEditor(text: $definition)
                .textEditorBackGround()
                .foregroundColor(definition.isEmpty ? .secondary : .white)
                .frame( height: 100)
                .cornerRadius(10)
            }
        }
    }
}

struct WordProposalView_Previews: PreviewProvider {
    static var previews: some View {
        WordProposalView(word: .constant("word"), definition: .constant("palimpseste"))
    }
}
