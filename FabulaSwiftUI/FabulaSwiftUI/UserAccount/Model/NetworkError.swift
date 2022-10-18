//
//  NetworkError.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 20/06/2022.
//

import Foundation

/// enum to keep track of the networkError
enum NetworkError: String, Error {
    case noData = "Aucune donnée."
    case noConnection = "Vérifiez votre connexion internet."
    case errorOccured = "Une erreur est survenue. Veuillez réessayer."
    case invalidEmail = "L'email n'est pas valide."
    case emailAlreadyUsed = "Cet email est déjà utilisé."
    case wrongPassWord = "Le mot de passe ne correspond pas à l'email."
    case weakPassword = "Le mot de passe n'est pas assez robuste."
    case noAccount = "Pas de compte associé à cet email."
}
