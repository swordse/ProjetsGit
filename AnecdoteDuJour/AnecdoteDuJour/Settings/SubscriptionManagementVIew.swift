//
//  SubscriptionManagementView.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 14/02/2023.
//

import SwiftUI

struct SubscriptionManagementView: View {
    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()
            MessageView(title: "Gestion de votre abonnement.", message: "Pour gérer votre abonnement, veuillez cliquer sur le lien ci-dessous :", content: {
                let stringUrl = "itms-apps://buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/DirectAction/manageSubscriptions"
                Link(stringUrl.getShortUrl(), destination: URL(string: stringUrl)!)
            })
//            .padding()
        }
    }
}


struct SubscriptionManagementView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionManagementView()
    }
}
