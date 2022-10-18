//
//  WelcomeData.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 13/10/2022.
//

import SwiftUI

struct WelcomeData {
    
    var imageName: String
    var categoryTitle: String
    var categoryDescription: String
    var color: Color?
    
    static var welcomeViewData = [WelcomeData(imageName: "Acceuil", categoryTitle: "Bienvenue sur Fabula", categoryDescription: "La meilleure façon d'apprendre simplement chaque jour.", color: nil),
                                  WelcomeData(imageName: "book", categoryTitle: "Anecdote", categoryDescription: "Découvrez chaque jour une nouvelle anecdote.", color: Color.pink), WelcomeData(imageName: "quote", categoryTitle: "Citation", categoryDescription: "Chaque jour une nouvelle citation.", color: Color.purple), WelcomeData(imageName: "bubble", categoryTitle: "Mot du jour", categoryDescription: "Enrichissez votre vocabulaire en découvrant la définition de mots inusuels.", color: Color(.systemBlue)), WelcomeData(imageName: "game", categoryTitle: "Quizz", categoryDescription: "Testez vos connaissances avec des quizz inédits.", color: Color("orange")), WelcomeData(imageName: "commentSubmit", categoryTitle: "Inscrivez-vous gratuitement", categoryDescription: "Pour pouvoir commenter et soumettre vos propres anecdotes", color: nil)]
}
