//
//  AccountManagerViewModel.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 21/07/2022.
//

import SwiftUI
import Firebase
import FirebaseStorage

extension AccountManagerView {
    
    final class AccountManagerViewModel: ObservableObject {
        
        @Published var photo : UIImage?
        @Published var userName = ""
        
        @Published var isShowingProgress = false
        @Published var showAlert = false
        @Published var alertMessage = (title: "", message: "")
        
        var currentUser: FabulaUser?
        var currentPhoto: UIImage?
        private let storage = Storage.storage().reference()
        
        // récupérer l'utilisateur actuel
        @MainActor
        func getCurrentUserInfo() {
            
            guard let user = UserDefaultsManager.manager.retrieveCurrentUser() else { return }
            currentUser = user
            userName = user.userName
            guard let stringUrl = user.userImage?.absoluteString else { return }
            loadImage(stringUrl: stringUrl)
            
        }
        
        @MainActor
        func loadImage(stringUrl: String?) {
            guard let stringUrl = stringUrl else {
                photo = nil
                return
            }
            
            guard let url = URL(string: stringUrl) else {
                photo = nil
                return }
            
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                Task.init(priority: .high, operation: {
                    guard let UIImage = UIImage(data: data) else { return }
                    DispatchQueue.main.async {
                        self.photo = UIImage
                        self.currentPhoto = UIImage
                    }
                })
            }
            task.resume()
        }
        
        func changeUserName() {
            isShowingProgress = true
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = userName
            changeRequest?.commitChanges(completion: { error in
                guard error == nil else {
                    self.isShowingProgress = false
                    self.alertMessage = (title: "Erreur", message: "Une erreur s'est produite. Veuillez réessayer ultérieurement et vérifier votre connexion internet.")
                    self.showAlert = true
                    return }
                self.isShowingProgress = false
                self.alertMessage = (title: "Merci", message: "Votre nom d'utilisateur a bien été modifié")
                self.showAlert = true
                self.currentUser?.userName = self.userName
                UserDefaultsManager.manager.saveCurrentUser(user: self.currentUser!)
            })
        }
     
        func changeUserPhoto() {
            isShowingProgress = true
            
            var imageData = Data()
            if photo != nil {
                
                let reduceHeightImage = photo!.aspectFittedToHeight(40)
                
                guard let data = reduceHeightImage.jpegData(compressionQuality: 0.1) else { return }
                imageData = data
            }
            guard let userId = currentUser?.userId else { return }
            
            self.storage.child("userImage/\(userId)").putData(imageData) { _, error in
                guard error == nil else { print("Failed to upload")
                    self.isShowingProgress = false
                    return
                }
                self.storage.child("userImage/\(userId)").downloadURL { url, error in
                    guard let url = url, error == nil else {
                        self.isShowingProgress = false
                        return
                    }
                    
                    // change photoUrl
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.photoURL = url
                    changeRequest?.commitChanges(completion: { error in
                        guard error == nil else {
                            self.isShowingProgress = false
                            self.alertMessage = (title: "Erreur", message: "Une erreur s'est produite. Veuillez réessayer ultérieurement et vérifier votre connexion internet.")
                            self.showAlert = true
                            return
                        }
                        self.currentPhoto = self.photo
                        self.isShowingProgress = false
                        self.alertMessage = (title: "Merci", message: "Votre photo a bien été modifiée.")
                        self.showAlert = true
                    })
                    self.currentUser?.userImage = url
                    UserDefaultsManager.manager.saveCurrentUser(user: self.currentUser!)
                }
            }
        }
    }
}
