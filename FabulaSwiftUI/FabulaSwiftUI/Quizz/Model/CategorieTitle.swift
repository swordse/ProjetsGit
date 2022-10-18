//
//  CategorieTitle.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 30/06/2022.
//

import Foundation

struct CategorieTitle: Codable {
    let categories: [Categorie]
}

struct Categorie: Codable {
    let categorieName: String
    let themes: [String]
}
