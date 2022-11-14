//
//  FASession.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 20/06/2022.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import Firebase
import SwiftUI

protocol FireAuthSession {
    /// FirebaseAuth create account. Use to create account, save user in userdefaults, save user in firebase
    /// - Parameters:
    ///   - userEmail: email
    ///   - password: password
    ///   - userName: userName
    ///   - completion: Result, Error
    func createAccount(userEmail: String, password: String, userName: String, userImage: UIImage?, completion: @escaping (_ photoUrl: URL?, _ userId: String?, _ error: NetworkError?) -> Void)
    /// call sign in method of FireAuth, return success or networkerror
    func signIn(email: String, password: String, completion: @escaping (FabulaUser?, NetworkError?) -> Void)
    /// retrieve the currentUser from FireAuthentification and return a FabulaUser
    func getCurrentUser() async throws -> FabulaUser?
    /// save user in FireStore, call during the account creation
    func saveUser(user: FabulaUser) async
    /// call logt our method of FireAuth, save deconnexion in userdDefaults
    func logOut()
    /// send an email if user forgot his password
    func passwordReset(email: String) -> Error?
    /// delete the user account from authservice
    func deleteUser() async throws -> ((title: String, message: String), networkError: NetworkError?)
}


final class AuthSession: FireAuthSession {
    
    
    private let storage = Storage.storage().reference()
    
    func createAccount(userEmail: String, password: String, userName: String, userImage: UIImage?, completion: @escaping (_ photoUrl: URL?, _ userId: String?, _ error: NetworkError?) -> Void)  {
        
        // create user in Authentification
        Auth.auth().createUser(withEmail: userEmail, password: password) { result, error in
            if error != nil, let error = error as? NSError {
                switch error.code {
                case AuthErrorCode.wrongPassword.rawValue:
                    completion(nil, nil, NetworkError.wrongPassWord)
                case AuthErrorCode.weakPassword.rawValue:
                    completion(nil, nil, NetworkError.weakPassword)
                case AuthErrorCode.invalidEmail.rawValue:
                    completion(nil, nil, NetworkError.invalidEmail)
                case AuthErrorCode.emailAlreadyInUse.rawValue:
                    completion(nil, nil, NetworkError.emailAlreadyUsed)
                case AuthErrorCode.networkError.rawValue:
                    completion(nil, nil, NetworkError.noConnection)
                default:
                    completion(nil, nil, NetworkError.errorOccured)
                }
            } else {
                
                // retrieve userID
                let userId = result?.user.uid
                
                // save userImage in storage and retrieve the image's url
                var photoUrl: URL?
                var imageData = Data()
                if userImage != nil {
                    guard let userImage = userImage else {
                        return
                    }
                    let reduceHeightImage = userImage.aspectFittedToHeight(40)
                    guard let data = reduceHeightImage.jpegData(compressionQuality: 0.1) else { return }
                    imageData = data
                }
                
                self.storage.child("userImage/\(userId!)").putData(imageData) { _, error in
                    guard error == nil else { print("Failed to upload")
                        return
                    }
                    self.storage.child("userImage/\(userId!)").downloadURL { url, error in
                        guard let url = url, error == nil else {
                            print("failed to get photoUrl")
                            return
                        }
                        photoUrl = url
                        completion(url, userId, nil)
                        
                        // create displayName and photoURL
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = userName
                        changeRequest?.photoURL = photoUrl
                        changeRequest?.commitChanges(completion: { error in
                            guard error == nil else {
                                completion(nil, nil, NetworkError.errorOccured)
                                return
                            }
                        })
                    }
                }
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (FabulaUser?, NetworkError?) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { authResult, error in
            if let error = error {
                let authError = error as NSError
                switch authError.code {
                case AuthErrorCode.invalidEmail.rawValue: completion(nil, NetworkError.invalidEmail)
                case AuthErrorCode.wrongPassword.rawValue:
                    completion(nil, NetworkError.wrongPassWord)
                case AuthErrorCode.userNotFound.rawValue, AuthErrorCode.userDisabled.rawValue:
                    completion(nil, NetworkError.noAccount)
                case AuthErrorCode.emailAlreadyInUse.rawValue:
                    completion(nil, NetworkError.emailAlreadyUsed)
                case AuthErrorCode.networkError.rawValue:
                    completion(nil, NetworkError.noConnection)
                default:
                    completion(nil, NetworkError.errorOccured)
                }
            }
            else {
                guard let result = authResult else { return }
                let userName = result.user.displayName ?? ""
                let userId = result.user.uid
                let userEmail = result.user.email ?? ""
                let userImage = result.user.photoURL
                
                let fabulaUser = FabulaUser(userName: userName, userId: userId, userEmail: userEmail, userImage: userImage)
                
                completion(fabulaUser, nil)
            }
        })
        
    }
    
    func getCurrentUser() -> FabulaUser? {
        
        guard let currentUser = Auth.auth().currentUser else {
            return nil }
        
        guard let email = currentUser.email else {
            return nil
        }
        
        let displayName = currentUser.displayName ?? ""
        let userImage = currentUser.photoURL
        let user = FabulaUser(userName: displayName, userId: currentUser.uid, userEmail: email, userImage: userImage)
        
        return user
    }
    // save user in firebase
    func saveUser(user: FabulaUser) async {
        let dataBase = Firestore.firestore()
        let docData: [String: Any] = [
            "userId": user.userId,
            "userName": user.userName,
            "userEmail": user.userEmail
        ]
        do {
            try await dataBase.collection("users").document().setData(docData)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func passwordReset(email: String) -> Error? {
        var returnError: Error?
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            returnError = error
        }
        return returnError
    }
    
    func deleteUser() async throws -> ((title: String, message: String), networkError: NetworkError?) {
        
        let user = Auth.auth().currentUser
        
        do {
            try await user?.delete()
            return ((title: "Succès", message: "Votre compte a été supprimé."), nil)
        } catch {
            print(error.localizedDescription)
            return ((title: "Succès", message: "Votre compte a été supprimé."), NetworkError.errorOccured)
        }
    }
    
}


