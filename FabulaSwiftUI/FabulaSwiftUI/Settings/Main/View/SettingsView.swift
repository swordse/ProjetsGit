//
//  SettingsView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 06/07/2022.
//

import SwiftUI

struct SettingsView: View {
    
    var body: some View {
    
        NavigationView {
            ZStack {
                        Color.background
                            .ignoresSafeArea()
                        Form {
                            ForEach(SettingsSection.settings, id: \.sectionTitle) { settingSection in
                                Section {
                                    ForEach(settingSection.settingsOptions, id: \.title) { option in
                                        NavigationLink {
                                            switch option.destination {
                                            case .toChangePhoto:
                                                AccountManagerView()
                                            case .toDeleteAccount:
                                                AccountView(isDeleteAccount: true)
                                            case .toReview:
                                                ReviewView()
                                            case .toAnecdoteFav:
                                                FavorisView(toDestination: option.destination)
                                            case .toCitationFav:
                                                FavorisView(toDestination: option.destination)
                                            case .toMotduJourFav:
                                                FavorisView(toDestination: option.destination)
                                            case .toScores: SettingsScoreView()
                                            case .toSubmitRules:
                                                LegalView(settingTitleText: SettingTitleText.submitRulesText, navTitle: "Règles Soumission")
                                            case .toCommentRules:
                                                LegalView(settingTitleText: SettingTitleText.commentRules, navTitle: "Règles Commentaires")
                                            case .toCGU:
                                                LegalView(settingTitleText: SettingTitleText.termsAndConditions, navTitle: "CGU")
                                            case.toRGPD: LegalView(settingTitleText: SettingTitleText.confidentiality, navTitle: "Données personnelles")
                                            case .toEmail :
                                                HomeEmailView()
                                            }
                                        } label: {
                                            GeometryReader { geo in
                                                HStack {
                                                    ZStack {
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .fill(option.iconBackgroundColor)
                                                            .frame(width: geo.size.width/7)
                                                        option.image?
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame(width: geo.size.width/12)
                                                            .font(.body.weight(.light))
                                                    }
                                                    Text(option.title)
                                                }
                                            }
                                        }
                                    }
                                } header: {
                                    Text(settingSection.sectionTitle)
                                }
                            }
                            .listRowBackground(Color.lightBackground)
                        }
                            .hideScrollBackground()
                        
                    }
            .navigationTitle(Text("Préférences"))
        }
            }
    }
    
    struct SettingsView_Previews: PreviewProvider {
        static var previews: some View {
            SettingsView()
        }
    }
