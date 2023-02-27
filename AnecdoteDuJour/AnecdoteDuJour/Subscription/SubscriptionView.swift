//
//  SubscriptionView.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 02/02/2023.
//

import SwiftUI
import Glassfy

struct SubscriptionView: View {
    
    @EnvironmentObject var iapModel: IAPViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var hasSeenRewardAd : Bool
    
    @State private var skus: [Glassfy.Sku] = []
    @State private var messageError: String = ""
    @State private var showAlert = false
    
    private let adViewControllerRepresentable = AdViewControllerRepresentable()
    private let adCoordinator = AdCoordinator()
    
    var body: some View {
            if iapModel.isLoading {
                ZStack{
                    Rectangle().fill(.ultraThinMaterial)
                    ProgressView()
                }.ignoresSafeArea()
            } else {
                ZStack {
                    Color("background")
                    
                    if !iapModel.isPremium && !hasSeenRewardAd {
                        VStack(spacing: 0) {
                            AppleSubscriptionView().environmentObject(iapModel)
//                            Text("Abonnez-vous :")
//                                .font(.title3)
//                                .fontWeight(.semibold)
//                                .padding(.bottom)
//                            VStack(alignment: .leading, spacing: 10) {
//                                HStack {
//                                    Image(systemName: "checkmark.circle.fill")
//                                        .foregroundColor(.green)
//                                    Text("Suppression de la publicité.")
//                                }
//                                HStack {
//                                    Image(systemName: "checkmark.circle.fill")
//                                        .foregroundColor(.green)
//                                    Text("Choix des catégories.")
//                                }
//                            }.padding(.bottom)
//                            if iapModel.products.isEmpty {
//                                ProgressView()
//                                    .padding()
//                            } else {
//                                VStack(spacing: 0) {
//                                    ForEach(iapModel.products, id: \.self) { sku in
//                                        Button {
//                                            iapModel.purchase(product: sku)
//                                        } label: {
//                                            VStack {
//                                                Text("\(sku.product.localizedTitle)")
//                                                Text("\(sku.product.priceLocale.currencySymbol ?? "") \(sku.product.price)")
//                                            }.frame(maxWidth: .infinity)
//                                        }.padding([.top, .bottom], 10)
//                                            .buttonStyle(.borderedProminent)
//                                            .alert(isPresented: $iapModel.showError) {
//                                                Alert(title: Text("Erreur"), message: Text(iapModel.errorMessage), dismissButton: .cancel())
//                                            }
//                                    }
//                                    Button {
//                                        iapModel.restorePurchase()
//                                    } label: {
//                                        HStack(spacing: 10) {
//                                            Image(systemName: "clock.arrow.2.circlepath")
//                                                .font(.caption)
//                                            Text("Restore")
//                                                .font(.callout)
//                                        }
//                                    }
//                                }.padding(.bottom)
//                            }
                            Text("Ou visionnez une publicité :")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .padding(.bottom, 0)
                            Button {
                                let ad = adCoordinator.presentAd(from: adViewControllerRepresentable.viewController) {
                                    hasSeenRewardAd = true
                                }
                                if ad != nil {
                                    messageError = ad!
                                    showAlert.toggle()
                                }
                            } label: {
                                Text("Regarder une publicité")
                                    .padding([.top, .bottom], 10)
                                    .frame(maxWidth: .infinity)
                            }
                            .padding()
                            .buttonStyle(.borderedProminent)
                            .alert(isPresented: $showAlert) {
                                Alert(title: Text("La publicité n'est pas chargée."), message: Text(messageError), dismissButton: .cancel())
                            }
                            Link("Terms of Service & Privacy Policy", destination: URL(string:"https://www.google.com")!)
                                .font(.caption)
                                .padding(.top, 10)
                        }
                        .padding(30)
                        .background(Color("cellBackground"))
                        .cornerRadius(10)
                        .background{ adViewControllerRepresentable
                            .frame(width: .zero, height: .zero)
                        }
                        .onAppear {
                            adCoordinator.loadAd()
                        }
                    } else if iapModel.isPremium {
                        MessageView(title: "MERCI !", message: "Votre abonnement a bien été enregistré.", content: { })
                            .padding(.horizontal, 10)
                    } else if hasSeenRewardAd && !iapModel.isPremium {
                        MessageView(title: "MERCI !", message: "Vous pouvez maintenant choisir une catégorie.", content: { })
                            .padding(.horizontal, 10)
                    }
                }
                .overlay(alignment: .topTrailing) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray.opacity(0.3))
                            .padding()
                    }

                }
            }
    }
}

struct SubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionView(hasSeenRewardAd: .constant(false))
            .environmentObject(IAPViewModel())
    }
}
