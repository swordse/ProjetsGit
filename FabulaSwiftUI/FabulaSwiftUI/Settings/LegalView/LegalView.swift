//
//  LegalView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 27/09/2022.
//

import SwiftUI

class LegalData {
    var title: String
    var url: String
    
    init(title: String = "", url: String = "") {
        self.title = title
        self.url = url
    }
    
}
struct LegalView: View {
    
//    var settingTitleText: [SettingTitleText]
//    var navTitle: String
    let legalDatas = [LegalData(title: "Conditions générales d'utilisation", url: "https://www.sites.google.com/view/appfabula/accueil/conditions-générales-dutilisation"), LegalData(title:"Données personnelles", url: "https://www.sites.google.com/view/appfabula/accueil/données-personnelles"), LegalData(title:"Règles de soumission", url: "https://www.sites.google.com/view/appfabula/accueil/règles-de-soumission"), LegalData(title: "Règles relatives aux commentaires", url: "https://www.sites.google.com/view/appfabula/accueil/règles-soumission-des-commentaires"), LegalData(title: "Licence Apple", url: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")]
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            List(legalDatas, id: \.self.title) { legalData in
                Button {
                    let stringUrl = legalData.url
                    let encoded = stringUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
                    
                    let url = URL(string: encoded!)
                    UIApplication.shared.open(url!)
                } label: {
                    Text(legalData.title)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .listRowBackground(Color.lightBackground)
            }
        }
        .background(Color.background)
        .hideScrollBackground()
        .navigationTitle("Mentions légales")
    }
}

struct LegalView_Previews: PreviewProvider {
    static var previews: some View {
        LegalView()
    }
}
