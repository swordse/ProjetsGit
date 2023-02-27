//
//  SheetMenu.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 19/01/2023.
//

import Foundation
import SwiftUI

struct SettingsSection {
    var sectionTitle: String
    var settingsOptions: [SettingsOption]
    
    static let shared = [SettingsSection(sectionTitle: "Vos anecdotes", settingsOptions: [SettingsOption(title: "Favoris", image: Image(systemName: "heart"), iconBackgroundColor: Color("red"), destination: .toAnecdoteFav)]),
                         SettingsSection(sectionTitle: "Evaluer", settingsOptions: [SettingsOption(title: "Noter Anecdote du jour", image: Image(systemName: "star"), iconBackgroundColor: .green, destination: .toReview), SettingsOption(title: "Partager AnecdoteDuJour", image: Image(systemName: "square.and.arrow.up"), iconBackgroundColor: .green, destination: .toShareApp)]),
                         SettingsSection(sectionTitle: "Abonnement", settingsOptions: [SettingsOption(title: "Abonnez-vous", image: Image("RemoveAd"), iconBackgroundColor: .pink, destination: .toAppleSubscription), SettingsOption(title: "Gérer votre abonnement", image: Image(systemName: "arrow.uturn.backward.circle"), iconBackgroundColor: .green, destination: .toSubscriptionManagement), SettingsOption(title: "Remboursement", image: Image(systemName: "dollarsign.circle"), iconBackgroundColor: .pink, destination: .toRefund)]),
                         SettingsSection(sectionTitle: "Légal & Contact", settingsOptions: [SettingsOption(title: "Légal", image: Image(systemName: "doc.plaintext"), iconBackgroundColor: .gray, destination: .toLegal), SettingsOption(title: "Contact", image: Image(systemName: "mail"), iconBackgroundColor: .blue, destination: .toEmail)])]
}

struct SettingsOption {
    var title: String
    var image: Image
    var iconBackgroundColor: Color
    var destination: Destination
}

enum Destination {
    case toAnecdoteFav
    case toLegal
    case toEmail
    case toReview
    case toShareApp
    case toAppleSubscription
    case toRefund
    case toSubscriptionManagement
}


