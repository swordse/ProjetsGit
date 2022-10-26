//
//  EmailConstants.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 16/10/2022.
//

import Foundation


struct EmailConstants {
    
    var email = "fabula.app.contact@gmail.com"
    
    let noSupportext = "Vous devez configurer votre compte email pour pouvoir nous envoyer un message."
        let contentPreText = "Voici mon retour concernant Fabula"
    let sendButtonText = "Envoyer un email"
    let subject = "Retour"
    
    static let shared = EmailConstants()
    
    init() { }
    
    
}
