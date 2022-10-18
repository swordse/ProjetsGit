//
//  AnecdoteProposalView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 23/06/2022.
//

import SwiftUI

struct AnecdoteProposalView: View {
    
    @Binding var source: String
    @Binding var anecdote: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(spacing: 10) {
        SubmitForm(image: ImageSubmitForm.source, categoryName: "Source")
        
        SuperTextField(isLightBlue: true, isSecured: false, placeholder: Text("source")
            .font(.system(size: 16, weight: .regular, design: .default)), textContentType: .name, keyboardType: .URL
            , text: $source)
        .foregroundColor(source.isEmpty ? .secondary : .white)
            }
        
            VStack(spacing: 10) {
        SubmitForm(image: ImageSubmitForm.text, categoryName: "Texte")

        TextEditor(text: $anecdote)
                    .textEditorBackGround()
            .foregroundColor(anecdote.isEmpty ? .secondary : .white)
            .frame( height: 100)
            .cornerRadius(10)
            }
        }
    }
}

struct AnecdoteProposalView_Previews: PreviewProvider {
    static var previews: some View {
        AnecdoteProposalView(source: .constant("source"), anecdote: .constant("super anecdote"))
    }
}
