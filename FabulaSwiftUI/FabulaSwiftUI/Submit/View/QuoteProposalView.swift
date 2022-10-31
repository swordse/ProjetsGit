//
//  QuoteView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 23/06/2022.
//

import SwiftUI

struct QuoteProposalView: View {
    
    @Binding var author: String
    @Binding var quoteSubmitted: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
        VStack(spacing: 10) {
            SubmitForm(image: ImageSubmitForm.author, categoryName: "Auteur")
            
            SuperTextField(isLightBlue: true, isSecured: false, placeholder: Text("   auteur")
                .font(.system(size: 16, weight: .regular, design: .default)), textContentType: .name, keyboardType: .default, text: $author)
            .foregroundColor(author.isEmpty ? .secondary : .white)
        }
            
        VStack(spacing: 10) {
            SubmitForm(image: ImageSubmitForm.text, categoryName: "Citation")

            TextEditor(text: $quoteSubmitted)
                .textEditorBackGround()
                .foregroundColor(.white)
                .frame( height: 100)
                .cornerRadius(10)
            }
        }
    }
}

struct QuoteProposalView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteProposalView(author: .constant("Bob"), quoteSubmitted: .constant("C'est le premier jour du reste de ta vie"))
    }
}
