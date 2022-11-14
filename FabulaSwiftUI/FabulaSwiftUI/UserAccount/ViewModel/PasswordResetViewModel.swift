//
//  PasswordResetViewModel.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 18/07/2022.
//

import Foundation

extension PasswordResetView {
    
    @MainActor final class PasswordResetViewModel: ObservableObject {
        
        @Published var alertMessage = (title: "", message: "")
        @Published var showAlert = false
        
        
        var authService = AuthService()
        
        func passwordReset(email: String) {
            let result = authService.passwordReset(email: email)
            if result != nil {
                alertMessage = (title: "Une erreur est survenue.", message: "Veuillez vérifiez votre email et recommencer.")
                showAlert = true
            } else {
                alertMessage = (title: "Merci", message: "Un email de réinitialisation vous a été envoyé.")
                showAlert = true
            }
        }
    }
    
    
}
