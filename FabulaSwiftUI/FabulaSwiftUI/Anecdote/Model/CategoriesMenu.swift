//
//  CategoriesMenu.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 07/06/2022.
//

import Foundation

enum CategoriesMenu: String, CaseIterable {
    case nouveautes = "Nouveautés"
    case favoris = "Vos Favoris"
    case histoire = "Histoire"
    case science = "Science"
    case art = "Art"
    case litterature = "Littérature"
    case insolite = "Insolite"
    case geographie = "Géographie"
    
    var description: String {
        return "Anecdote Category Menu"
    }
}
