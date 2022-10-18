//
//  Quote.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 11/06/2022.
//

import Foundation
import Firebase

struct Quote: Codable, Equatable, Hashable {
    
    var author: String
    var text: String
    var category: Category
    var isFavorite = false
    
    enum Category: String, Codable {
        case amour = "Amour"
        case amitie = "Amitié"
        case absurde = "Absurde"
        case divers = "Divers"
        case exigence = "Exigence"
        case femme = "Femme"
        case homme = "Homme"
        case impossible = "Impossible"
        case monde = "Monde"
        case succes = "Succès"
        case temps = "Temps"
        case travail = "Travail"
        case vie = "Vie"
    }
    
}

class QuoteState {
    var quotes: [Quote]
    var snapshots: [QueryDocumentSnapshot?]
    var page: Int
    
    init(quotes: [Quote], snapshots: [QueryDocumentSnapshot?], page: Int) {
        self.quotes = quotes
        self.snapshots = snapshots
        self.page = page
    }
}
