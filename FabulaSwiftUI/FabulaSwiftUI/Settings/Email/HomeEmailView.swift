//
//  HomeEmailView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 16/10/2022.
//

import SwiftUI
import MessageUI

struct HomeEmailView: View {
    
    @State private var showEmail = false
    let constant = EmailConstants.shared
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            VStack(spacing: 40) {
                if MFMailComposeViewController.canSendMail() {
                    Text("Envoyez nous un email pour nous poser vos questions ou nous faire part de votre expérience.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                    Button {
                        showEmail.toggle()
                    } label: {
                        ButtonView(text: constant.sendButtonText)
                    }
                } else {
                    Text(constant.noSupportext)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                }
            }
            .padding()
        }
        .sheet(isPresented: $showEmail) {
            MailView(content: constant.contentPreText, to: constant.email, subject: constant.subject)
        }
        .navigationTitle("Contact")
    }
}

struct HomeEmailView_Previews: PreviewProvider {
    static var previews: some View {
        HomeEmailView()
    }
}
