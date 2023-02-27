//
//  SettingSubscriptionView.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 14/02/2023.
//

import SwiftUI

struct SettingSubscriptionView: View {
    
    @EnvironmentObject var iapModel: IAPViewModel
    
    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()
            if !iapModel.isPremium {
                AppleSubscriptionView()
                    .padding(30)
                    .background { Color("cellBackground")}.cornerRadius(10)
            } else {
                MessageView(title: "Vous êtes abonné.", message: "Vous pouvez modifier votre abonnement dans la section: Gérez votre Abonnement.", content: { })
            }
        }
    }
}

struct SettingSubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SettingSubscriptionView()
    }
}
