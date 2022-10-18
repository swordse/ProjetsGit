//
//  ReviewView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 11/10/2022.
//
import StoreKit
import SwiftUI

struct ReviewView: View {
    
    
    
    var body: some View {
        
        ZStack {
            Color.background
                .ignoresSafeArea()
            VStack(spacing: 40) {
                Text("MERCI !")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("En soumettant votre avis sur notre application, vous soutenez nos efforts.")
                    .multilineTextAlignment(.center)
                Button {
                    guard let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive}) as? UIWindowScene else { return }
                    SKStoreReviewController.requestReview(in: scene)
                } label: {
                    Text("Soumettre une évaluation.")
                }
            }
        }
        
    }
}


struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewView()
    }
}
