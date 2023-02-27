//
//  SettingMailView.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 25/01/2023.
//

import SwiftUI
import MessageUI

struct SettingMailView: View {
    
    @State private var showMail = false
    var emailConstants = EmailConstants.shared
    
    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea()
            if MFMailComposeViewController.canSendMail() {
                VStack(alignment: .center) {
                    Text("Contactez nous")
                        .fontWeight(.bold)
                    Text("Envoyez nous un email pour nous poser vos questions ou nous faire part de votre expérience.")
                        .multilineTextAlignment(.center)
                        .padding()
                    Button {
                        showMail = true
                    } label: {
                        Text(emailConstants.sendButtonText)
                    }
                }.padding()
                    .background(Color("cellBackground"))
                    .cornerRadius(10)
                    .padding(.horizontal)
            } else {
                MessageView(title: "Configurez votre messagerie", message: emailConstants.noSupportext, content: {

                })
                    .padding(.horizontal)
//                Text(emailConstants.noSupportext)
//                    .multilineTextAlignment(.center)
//                    .padding()
            }
        }
    }
}

struct SettingMailView_Previews: PreviewProvider {
    static var previews: some View {
        SettingMailView()
    }
}
