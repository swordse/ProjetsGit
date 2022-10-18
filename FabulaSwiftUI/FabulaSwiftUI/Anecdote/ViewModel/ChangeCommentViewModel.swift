//
//  ChangeCommentViewModel.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 23/07/2022.
//

import Foundation

extension ChangeCommentView {
    
    @MainActor class ChangeCommentViewModel: ObservableObject {
        
        let session = CommentService()
        
        @Published var showAlert = false
        @Published var alertMessage = (title: "", message: "")
        @Published var showProgressView = false
        
        func updateComment(comment: Comment) {
            showProgressView.toggle()
            session.update(comment: comment) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case.success:
                        self?.showProgressView.toggle()
                        self?.alertMessage = (title: "Merci", message: "Votre commentaire a été modifié.")
                        self?.showAlert = true
                    case.failure:
                        self?.showProgressView.toggle()
                        self?.alertMessage = (title: "Erreur", message: "Une erreur s'est produite. Veuillez réessayer ultérieurement et vérifier votre connexion internet.")
                        self?.showAlert = true
                    }
                }
            }
        }
    }
}
