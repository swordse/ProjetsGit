//
//  CategoryModel.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 27/01/2023.
//

import Foundation

//let categories = ["Art", "Divertissement", "Géographie", "Histoire", "Inclassable", "Insolite", "Littérature", "Nature", "Science", "Société", "Sport", "Vie pratique"]

struct CategoryModel {
    
    var name: String
    var image: String
    var color: [String]
    
    static let categories = [CategoryModel(name: "Nouveautés", image: "Nouveautés", color: ["Nouveautés", "Nouveautés Dark"]),
                             CategoryModel(name: "Art", image: "Art", color: ["Art", "Art Dark"]),
                             CategoryModel(name: "Divertissement", image: "Divertissement", color: ["Divertissement", "Divertissement Dark"]),
                             CategoryModel(name: "Géographie", image: "Géographie", color: ["Géographie", "Géographie Dark"]),
                             CategoryModel(name: "Histoire", image: "Histoire", color: ["Histoire", "Histoire Dark"]),
                             CategoryModel(name: "Inclassable", image: "Inclassable", color: ["Inclassable", "Inclassable Dark"]),
                             CategoryModel(name: "Insolite", image: "Insolite", color: ["Insolite", "Insolite Dark"]),
                             CategoryModel(name: "Littérature", image: "Littérature", color: ["Littérature", "Littérature Dark"]),
                             CategoryModel(name: "Nature", image: "Nature", color: ["Nature", "Nature Dark"]),
                             CategoryModel(name: "Science", image: "Science", color: ["Science", "Science Dark"]),
                             CategoryModel(name: "Société", image: "Société", color: ["Société", "Société Dark"]),
                             CategoryModel(name: "Sport", image: "Sport", color: ["Sport", "Sport Dark"]),
                             CategoryModel(name: "Vie pratique", image: "Vie pratique", color: ["Vie pratique", "Vie pratique Dark"])]
}
