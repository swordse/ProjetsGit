//
//  QuoteCategories.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 11/06/2022.
//

import Foundation

protocol ScrollCategories { }

enum QuoteCategoriesMenu: String, CaseIterable, ScrollCategories {
    
    case nouveautes = "Nouveautés"
    case favoris = "Vos Favoris"
//    case themes = "Catégorie"
    case absurde = "Absurde"
    case amour = "Amour"
    case amitie = "Amitié"
    case exigence = "Exigence"
    case femme = "Femme"
    case homme = "Homme"
    case impossible = "Impossible"
    case monde = "Monde"
    case mort = "Mort"
    case success = "Succès"
    case temps = "Temps"
    case travail = "Travail"
    case vie = "Vie"
    

}