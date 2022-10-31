//
//  AuthView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 29/10/2022.
//

import SwiftUI

class AuthViewModel: ObservableObject {
    
    @Published var storeCredentialsNext = false
    
    let credentials = Credentials(password: "", email: "")
    
    func loginFunc() {
        // if login success
        if storeCredentialsNext {
            if KeychainStorage.saveCredentials(credentials) {
                storeCredentialsNext = false
            }
        }
    }
}

struct AuthView: View {
    
    
    let authentification = Authentification()
    
    @State private var credentials: Credentials?
    @State private var faceIdError : Authentification.AuthentificationError? = nil
    var body: some View {
        
        // ajouter ce check à la vue par exemple sous les boutons de connexion pour vérifier que l'authentification est possible: si oui cela fera apparaitre un bouton avec l'image faceId
        if authentification.biometricType() != .none {
            Button {
                authentification.requestBiometricUnlock { (result: Result <Credentials, Authentification.AuthentificationError>) in
                    
                    switch result {
                    case .success(let credentials):
                        self.credentials = credentials
                        // appeler la fonction de login avec ces credentials
                    case .failure(let error):
                        print(error)
                        faceIdError = error
                        // appeler une alert avec l'erreur
                    }
                }
            } label: {
                Image(systemName: authentification.biometricType() == .face ? "faceid" : "touchid")
                    .resizable()
                    .frame(width: 50, height: 50)
                
            }
            .alert(item: $faceIdError) { error in
                if error == .credentialsNotSaved {
                    return Alert(title: Text("Identifiants non sauvés"), message: Text(error.localizedDescription), primaryButton: .default(Text("OK"), action: {
                        // ici pas de credential enregistrés donc on fait en sorte que le view model les enregistre lors de la suivante authentification
                        AuthViewModel().storeCredentialsNext = true
                    }),
                                 secondaryButton: .cancel())
                } else {
                    return Alert(title: Text("Invalid login"))
                }
            }
        }
            
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
