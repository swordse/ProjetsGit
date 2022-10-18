//
//  LegalView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 27/09/2022.
//

import SwiftUI

struct LegalView: View {
    
    var settingTitleText: [SettingTitleText]
    var navTitle: String
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            ScrollView {
                ForEach(settingTitleText, id: \.self.text) { text in
                    
                    /*@START_MENU_TOKEN@*/Text(text.title)/*@END_MENU_TOKEN@*/
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    Text(text.text)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                }
            }
        }
        .navigationTitle(navTitle)
    }
}

struct LegalView_Previews: PreviewProvider {
    static var previews: some View {
        LegalView(settingTitleText: [SettingTitleText(title: "bob", text: "le bob")], navTitle: "BOB")
    }
}
