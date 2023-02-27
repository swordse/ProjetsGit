//
//  LegalView.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 19/01/2023.
//

import SwiftUI

final class LegalData {
    var title: String
    var url: String
    
    init(title: String = "", url: String = "") {
        self.title = title
        self.url = url
    }
}

struct LegalView: View {
    
    let legalDatas = [LegalData(title: "Conditions générales d'utilisation", url: "https://fabulaapp.blogspot.com/p/cgu.html"), LegalData(title:"Données personnelles", url: "https://fabulaapp.blogspot.com/p/donnees-caractere-personnel_12.html"), LegalData(title:"Règles de soumission", url: "https://fabulaapp.blogspot.com/p/regles-de-soumission.html"), LegalData(title: "Règles relatives aux commentaires", url: "https://fabulaapp.blogspot.com/p/commentaires.html"), LegalData(title: "Licence Apple", url: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")]
    
    var body: some View {
        ZStack {
            
            Color("background")
                .ignoresSafeArea()
            
            List(legalDatas, id: \.self.title) { legalData in
                Button {
                    legalData.url.openUrl()
                    
                } label: {
                    Text(legalData.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .listRowBackground(Color("cellBackground"))
            }
            .hideScrollBackground()
        }
        .navigationTitle("Mentions légales")
    }
}

struct LegalView_Previews: PreviewProvider {
    static var previews: some View {
        LegalView()
    }
}
