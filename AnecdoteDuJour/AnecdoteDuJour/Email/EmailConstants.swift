//
//  EmailConstants.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 25/01/2023.
//

import Foundation

/// Constant text to configure email
struct EmailConstants {
    
    static let shared = EmailConstants()
    
    init() { }
    
    var email = "fabula.app.contact@gmail.com"
    
    let noSupportext = "Vous devez configurer votre compte email pour pouvoir nous envoyer un message."
    let contentPreText = "Voici mon retour concernant Fabula"
    let sendButtonText = "Envoyer un email"
    let subject = "Retour"
    
}
