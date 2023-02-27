//
//  RefundView.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 09/02/2023.
//

import SwiftUI

struct RefundView: View {
    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()
            VStack(spacing: 30) {
                Text("Pour obtenir un remboursement, vous pouvez suivre la procédure suivante :")
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                VStack(alignment: .leading, spacing: 20) {
                    Text("1. Connectez-vous avec votre compte Apple à l'adresse suivante :")
                    Link("reportaproblem.apple.com", destination: URL(string: "https://reportaproblem.apple.com/?s=6")!).frame(maxWidth: .infinity)
                    Text("2. Cliquez sur \"i'd like to\" et choisissez \"Request a refund\".")
                    Text("3. Choisissez la raison pour laquelle vous souhaitez un remboursement puis choisissez Next.")
                    Text("4. Choisissez \"Cancel the subscription\".")
                }.padding()
                Text("Pour plus de précision, consultez l'adresse suivante :")
                    .multilineTextAlignment(.center)
                Link("request a refund", destination: URL(string: "https://support.apple.com/en-us/HT204084")!)
            }
            .padding()
            .background { Color("cellBackground")}
            .cornerRadius(10)
            .padding()
            
        }
    }
}

struct RefundView_Previews: PreviewProvider {
    static var previews: some View {
        RefundView()
    }
}
