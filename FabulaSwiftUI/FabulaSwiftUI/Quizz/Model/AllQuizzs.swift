//
//  AllQuizzs.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 30/06/2022.
//

import Foundation
import SwiftUI

struct AllQuizzs: Codable {
    let quizzs: [Quizz]
}

struct Quizz: Codable {
    let question: String
    let answer: String
    let propositions: [String]
}

// enum to keep track of the available category
enum QuizzCategory: String {
    case histoire = "Histoire"
    case science = "Science"
    case litterature = "Littérature"
    case art = "Art"
    case loisirs = "Loisirs"
    case nature = "Nature"
    case geographie = "Géographie"
    case sport = "Sport"
}
// struct to associate display info to category
struct QuizzCategoryInfo {
    var name: String
    var image: Image
    var color: Color
}
