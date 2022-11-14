//
//  SettingsModel.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 06/07/2022.
//

import Foundation
import SwiftUI

struct SettingTitleText {
    let title: String
    let text: String
}

struct SettingsSection {
    var sectionTitle: String
    var settingsOptions: [SettingsOption]
    
    static var settings: [SettingsSection] = [
        SettingsSection(sectionTitle: "Favoris", settingsOptions: [
            SettingsOption(title: "Anecdote", image: Image("book"), iconBackgroundColor: .pink, destination: .toAnecdoteFav),
            SettingsOption(title: "Citations", image: Image("quote"), iconBackgroundColor: .purple, destination: .toCitationFav),
            SettingsOption(title: "Mot du jour", image: Image("bubble"), iconBackgroundColor: .blue, destination: .toMotduJourFav)
            ]),
        SettingsSection(sectionTitle: "Scores", settingsOptions: [
            SettingsOption(title: "Vos scores aux quizz", image: Image("game"), iconBackgroundColor: Color("orange"), destination: .toScores)]),
        SettingsSection(sectionTitle: "Notez Fabula", settingsOptions: [
            SettingsOption(title: "Vous aimez Fabula, notez la.", image: Image(systemName: "star") , iconBackgroundColor: Color.purple, destination: .toReview)
            ]),
    SettingsSection(sectionTitle: "Gérez votre compte", settingsOptions: [
        SettingsOption(title: "Modifiez votre profil", image: Image(systemName: "camera") , iconBackgroundColor: .green, destination: .toChangePhoto),
        SettingsOption(title: "Supprimez votre compte", image: Image(systemName: "person"), iconBackgroundColor: .red, destination: .toDeleteAccount)
        ]),
    SettingsSection(sectionTitle: "Juridique", settingsOptions: [SettingsOption(title: "Mentions légales/ GCU", image: Image(systemName: "doc.plaintext"), iconBackgroundColor: .gray, destination: .toLegal)]),
    SettingsSection(sectionTitle: "Contact", settingsOptions: [SettingsOption(title: "Email", image: Image(systemName: "mail"), iconBackgroundColor: Color("nature"), destination: .toEmail)])
    
    ]
}

struct SettingsOption {
    var title: String
    var image: Image?
    var iconBackgroundColor: Color
    var destination: Destination
}

enum Destination {
    case toDeleteAccount
    case toChangePhoto
    case toReview
    case toAnecdoteFav
    case toCitationFav
    case toMotduJourFav
    case toScores
    case toLegal
    case toEmail
}
