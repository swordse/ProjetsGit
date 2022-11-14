//
//  AccountViewModel.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 20/06/2022.
//

import Foundation
import SwiftUI

extension AccountView {
    
    @MainActor
    final class AccountViewModel: ObservableObject {
        
        let authService = AuthService()
        let userDefaultsManager = UserDefaultsManager.manager
        
        var currentUser: FabulaUser?
        
        @Published var storeCredentialsNext = false
        
        @Published var isConnexion = true
        @Published var userImage: UIImage?
        @Published var userName = ""
        @Published var email = ""
        @Published var password = ""
        @Published var confirmationPassword = ""
        @Published var alertMessage = (title: "", message: "")
        @Published var showAlert = false
        @Published var isShowingProgress = false
        @Published var signInForDeleteIsSuccess = false
        
        enum AlertMessage: String {
            case empty = "Vous n'avez pas complété tous les champs."
            case invalidEmail = "L'email renseigné n'est pas valide."
            case weakPassword = "Le mot de passe n'est pas assez long"
            case differentPassword = "Le mot de passe et sa confirmation ne correspondent pas."
            case creationFailed = "La création a échoué. Merci de recommencer."
            case success = "Votre compte a été créé"
        }
        
        private var isValidEmail : Bool {
            let emailValidationRegex = "^[\\p{L}0-9!#$%&'*+\\/=?^_`{|}~-][\\p{L}0-9.!#$%&'*+\\/=?^_`{|}~-]{0,63}@[\\p{L}0-9-]+(?:\\.[\\p{L}0-9-]{2,7})*$"
            
            let emailValidationPredicate = NSPredicate(format: "SELF MATCHES %@", emailValidationRegex)
            
            return emailValidationPredicate.evaluate(with: email)
        }
        
        private var isPasswordStrong : Bool {
            let passwordPattern = #"(?=.{6,})"# + #"(?=.*[A-Z])"# + #"(?=.*[a-z])"# + #"(?=.*\d)"# + #"(?=.*[ @!$%&?._-])"#
            
            let result = password.range(
                of: passwordPattern,
                options: .regularExpression
            )
            
            return result != nil
        }
        
        private var isConfirmationCorrect: Bool {
            return password == confirmationPassword ? true : false
        }
        
        func checkCurrentUser() {
            Task {
                do {
                    currentUser = try await authService.getCurrentUser()
                    if currentUser != nil {
                        userDefaultsManager.saveCurrentUser(user: currentUser!)
                    }
                } catch {
                    print(error)
                }
            }
        }
        
        func dispatcher() {
            if isConnexion {
                checkConnexionForm()
            } else {
                checkCreationForm()
            }
        }
        
        private func checkConnexionForm() {
            if isValidEmail {
                signIn(password: password, email: email)
            } else {
                showAlert = true
                alertMessage = ("Erreur", "L'email n'est pas correct")
            }
        }
        
        private func checkCreationForm() {
            if isValidEmail && isPasswordStrong && isConfirmationCorrect {
                createUser()
            } else if email.isEmpty || password.isEmpty || confirmationPassword.isEmpty {
                isShowingProgress.toggle()
                alertMessage = (title: "Erreur", message: AlertMessage.empty.rawValue)
                showAlert = true
            } else if !isValidEmail {
                isShowingProgress.toggle()
                alertMessage = (title: "Erreur", message:AlertMessage.invalidEmail.rawValue)
                showAlert = true
            } else if !isPasswordStrong {
                isShowingProgress.toggle()
                alertMessage = (title: "Erreur", message:AlertMessage.weakPassword.rawValue)
                showAlert = true
            } else if !isConfirmationCorrect {
                isShowingProgress.toggle()
                alertMessage = (title: "Erreur", message:AlertMessage.differentPassword.rawValue)
                showAlert = true
            }
        }
        
        func signInForDelete() {
            isShowingProgress.toggle()
            Task {
                do {
                    authService.signIn(email: email, password: password) { [weak self] fabulaUser, error in
                        
                        if let authError = error {
                            self?.isShowingProgress.toggle()
                            self?.alertMessage = (title: "Erreur", message: authError.rawValue)
                            self?.showAlert.toggle()
                            self?.signInForDeleteIsSuccess = false
                        } else {
                            self?.isShowingProgress.toggle()
                            self?.signInForDeleteIsSuccess = true
                        }
                    }
                }
            }
        }
        
        
        func signIn(password: String, email: String) {
            isShowingProgress.toggle()
            Task {
                do {
                    authService.signIn(email: email, password: password) { [weak self] fabulaUser, error in
                        
                        if let authError = error {
                            self?.isShowingProgress.toggle()
                            self?.alertMessage = (title: "Erreur", message: authError.rawValue)
                            self?.showAlert.toggle()
                        } else {
                            if let fabulaUser = fabulaUser {
                                self?.isShowingProgress.toggle()
                                self?.saveCurrentUser(currentUser: fabulaUser)
                                if self?.storeCredentialsNext == true {
                                    if KeychainStorage.saveCredentials(Credentials(password: password, email: email)) {
                                        self?.storeCredentialsNext = false
                                    }
                                }
                            } else {
                                self?.isShowingProgress.toggle()
                                self?.alertMessage = (title: "Erreur", message: "Une erreur s'est produite. Veuillez réessayer.")
                                self?.showAlert.toggle()
                            }
                        }
                    }
                }
            }
        }
        
        func logOut() {
            isShowingProgress = true
            authService.logOut()
            userDefaultsManager.removeCurrentUser()
            email = ""
            password = ""
            isShowingProgress = false
        }
        
        func createUser() {
            isShowingProgress.toggle()
            authService.createAccount(userEmail: email, password: password, userName: userName, userImage: userImage) { [weak self] photoUrl, userId, error in
                if userId != nil {
                    self?.isShowingProgress.toggle()
                    if KeychainStorage.saveCredentials(Credentials(password: self!.password, email: self!.email)) {
                        print("KeyChaineStorage is saved")
                    } else {
                        print("ERROR KeyChaineStorage")
                    }
                    self?.alertMessage = (title: "Merci!", message:"Votre compte a été créé.")
                    self?.showAlert = true
                    let currentUser = FabulaUser(userName: self!.userName, userId: userId!, userEmail: self!.email, userImage: photoUrl)
                    self?.saveCurrentUser(currentUser: currentUser)
                } else {
                    guard let errorOccured = error else { return }
                    self?.isShowingProgress.toggle()
                    self?.alertMessage = (title: "Erreur", message: errorOccured.rawValue)
                    self?.showAlert = true
                }
            }
        }
        
        func saveCurrentUser(currentUser: FabulaUser) {
            userDefaultsManager.saveCurrentUser(user: currentUser)
        }
        
        func deleteUser() {
            isShowingProgress.toggle()
            Task{
                do {
                    let ((title: title, message: message), _) = try await authService.deleteUser()
                    self.alertMessage = (title: title, message: message)
                    showAlert.toggle()
                    userDefaultsManager.removeCurrentUser()
                    isShowingProgress.toggle()
                    email = ""
                    password = ""
                } catch {
                    print(error)
                }
            }
        }
    }
}
