//
//  AppleSubscriptionView.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 09/02/2023.
//

import SwiftUI
import Glassfy

struct AppleSubscriptionView: View {
    
    @EnvironmentObject var iapModel: IAPViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Abonnez-vous :")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.bottom)
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Suppression de la publicité.")
                }
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Choix des catégories.")
                }
            }.padding(.bottom)
            if iapModel.products.isEmpty {
                ProgressView()
                    .padding()
            } else {
                VStack(spacing: 0) {
                    ForEach(iapModel.products, id: \.self) { sku in
                        Button {
                            iapModel.purchase(product: sku)
                        } label: {
                            VStack {
                                Text("\(sku.product.localizedTitle)")
                                Text(localizedPrice(sku: sku))
//                                Text("\(sku.product.priceLocale.currencySymbol ?? "") \(sku.product.price)")
                            }.frame(maxWidth: .infinity)
                        }.padding([.top, .bottom], 10)
                            .buttonStyle(.borderedProminent)
                            .alert(isPresented: $iapModel.showError) {
                                Alert(title: Text("Erreur"), message: Text(iapModel.errorMessage), dismissButton: .cancel())
                            }
                    }
                    Button {
                        iapModel.restorePurchase()
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "clock.arrow.2.circlepath")
                                .font(.caption)
                            Text("Déjà abonné ? Rafraichissez")
                                .font(.callout)
                        }
                    }
                    .padding(.bottom)
                }
            }
        }
    }
    
    func localizedPrice(sku: Glassfy.Sku) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: sku.product.price)!
    }
}

struct AppleSubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        AppleSubscriptionView()
    }
}
