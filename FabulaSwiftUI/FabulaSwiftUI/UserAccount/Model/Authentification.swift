//
//  Authentification.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 29/10/2022.
//

import SwiftUI
import LocalAuthentication

class Authentification: ObservableObject {
    
    @Published var isAuthorized = false
    
    enum BiometricType {
        case none
        case face
        case touch
    }
    
    enum AuthentificationError: Error, LocalizedError, Identifiable {
        
        case deniedAccess
        case noFaceIdEnrolled
        case noFingerprintEnrolled
        case biometricError
        case credentialsNotSaved
        
        var id: String {
            self.localizedDescription
        }
        
        var errorDescription: String? {
            switch self {
            case .deniedAccess:
                return NSLocalizedString("Vous avez refusé l'utilisation de FaceId. Pour l'activer, rendez-vous dans vos réglages puis sur l'application Fabula.", comment: "")
            case .noFaceIdEnrolled:
                return NSLocalizedString("Vous n'avez enregistré aucun FaceId", comment: "")
            case .noFingerprintEnrolled:
                return NSLocalizedString("Vous n'avez enregistré aucune empreinte digitale", comment: "")
            case .biometricError:
                return NSLocalizedString("FaceId ou votre empreinte n'a pas été reconnue", comment: "")
            case .credentialsNotSaved:
                return NSLocalizedString("Vos identifiants n'ont pas été sauvegardés. Voulez-vous les sauvegarder lors de la prochaine connexion?", comment: "")
            }
        }
    }
    
    func biometricType() -> BiometricType {
        let authContext = LAContext()
        let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch authContext.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touch
        case .faceID:
            return .face
        @unknown default:
            return .none
        }
    }
    
    func requestBiometricUnlock(completion: @escaping (Result<Credentials, AuthentificationError>) -> Void) {
        let credentials = KeychainStorage.getCredentials()
        
        guard let credentials = credentials else {
            completion(.failure(.credentialsNotSaved))
            return
        }
        
        let context = LAContext()
        var error: NSError?
        let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        if let error = error {
            switch error.code {
            case -6:
                completion(.failure(.deniedAccess))
            case -7:
                if context.biometryType == .faceID {
                    completion(.failure(.noFaceIdEnrolled))
                } else {
                    completion(.failure(.noFingerprintEnrolled))
                }
            default:
                completion(.failure(.biometricError))
            }
            return
        }
        if canEvaluate {
            if context.biometryType != .none {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Nous devons accéder à vos identifiants") { success, error in
                    DispatchQueue.main.async {
                        if error != nil {
                            completion(.failure(.biometricError))
                        } else {
                            completion(.success(credentials))
                        }
                    }
                }
            }
        }
    }
}


