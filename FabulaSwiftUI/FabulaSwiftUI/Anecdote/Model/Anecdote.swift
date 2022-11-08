//
//  Anecdote.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 01/06/2022.
//

import Foundation
import Firebase

struct Anecdote: Identifiable, Hashable, Codable, Equatable, FavorisProtocol {
    
    var id: String?
    var category: Category
    var title: String
    var text: String
    var source: String?
    var date: Timestamp?
    var isFavorite: Bool
    
    // categories of the anecdotes
    enum Category: String, Codable, CaseIterable {
        case nouveautes = "Nouveautés"
        case favoris = "Favoris"
        case arts = "Art"
        case divertissement = "Divertissement"
        case geographie = "Géographie"
        case histoire = "Histoire"
        case inclassable = "Inclassable"
        case insolite = "Insolite"
        case litterature = "Littérature"
        case nature = "Nature"
        case science = "Science"
        case societe = "Société"
        case sport = "Sport"
        case viePratique = "Vie pratique"
    }
    
}
/// struct to keep anecdotes loaded, last snapshots for firebase an page for pagination
class AnecdoteState {
    var anecdotes: [Anecdote]
    var snapshots: [QueryDocumentSnapshot?]
    var page: Int
    
    init(anecdotes: [Anecdote], snapshots: [QueryDocumentSnapshot?], page: Int) {
        self.anecdotes = anecdotes
        self.snapshots = snapshots
        self.page = page
    }
}

