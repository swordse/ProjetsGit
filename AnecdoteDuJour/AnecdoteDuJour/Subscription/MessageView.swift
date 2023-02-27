//
//  SubscriptionMessageView.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 09/02/2023.
//

import SwiftUI

struct MessageView<Content: View>: View {
    
    let title: String
    let message: String
    @ViewBuilder var content: () -> Content
//    let urlLink: String?
    
    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .fontWeight(.bold)
            Text(message)
                .multilineTextAlignment(.center)
                .padding()
            content()
//            if let stringUrl = urlLink {
//                Link(stringUrl.getShortUrl(), destination: URL(string: stringUrl)!)
//            }
        }.padding()
            .background(Color("cellBackground"))
            .cornerRadius(10)
    }
}

//struct MessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageView<<#Content: View#>>(content: Text("Bob"), title: "MERCI", message: "Vous pouvez désormais sélectionner une catégorie.")
//    }
//}
