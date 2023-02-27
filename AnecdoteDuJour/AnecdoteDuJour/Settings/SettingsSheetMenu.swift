//
//  SheetMenu.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 19/01/2023.
//

import SwiftUI

struct SettingsSheetMenu: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var iapModel : IAPViewModel
    
    //    @Binding var isPresented: Bool
    //    @Environment(\.dismiss) var dismiss
    var settingsSection = SettingsSection.shared
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("background").ignoresSafeArea()
                //                VStack(alignment: .leading) {
                Form {
                    ForEach(settingsSection, id: \.sectionTitle) { section in
                        Section {
                            ForEach(section.settingsOptions, id: \.title) { menu in
                                NavigationLink {
                                    switch menu.destination {
                                    case.toLegal: LegalView()
                                    case .toAnecdoteFav:
                                        FavoritesView()
                                    case .toEmail:
                                        SettingMailView()
                                    case .toReview:
                                        ReviewView()
                                    case .toShareApp:
                                        ShareAppView()
                                    case .toAppleSubscription:
                                        //                                            SubscriptionManagmnentView()
                                        SettingSubscriptionView()
                                    case .toRefund:
                                        RefundView()
                                    case .toSubscriptionManagement:
                                        SubscriptionManagementView()
                                    }
                                } label: {
                                    HStack {
                                        menu.image.frame(width: 20)
                                        Text(menu.title)
                                    }
                                }
                            }
                        } header: {
                            Text(section.sectionTitle.uppercased())
                        }
                        //                            .background(Color("background"))
                    }
                    .listRowBackground(Color("cellBackground"))
                }
                .hideScrollBackground()
                .listStyle(.plain)
                //                }
                .toolbar {
                    ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.gray.opacity(0.3))
                        }
                        
                    }
                }
                .navigationTitle("Réglages")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .onAppear {
            iapModel.checkPurchase()
        }
    }
}

struct SheetMenu_Previews: PreviewProvider {
    static var previews: some View {
        SettingsSheetMenu()
    }
}
