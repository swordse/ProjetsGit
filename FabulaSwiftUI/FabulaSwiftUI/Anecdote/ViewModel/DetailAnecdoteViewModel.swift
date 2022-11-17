//
//  DetailAnecdoteViewModel.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 02/06/2022.
//

import Foundation
import Firebase

extension DetailAnecdoteView {
    
    @MainActor final class DetailAnecdoteViewModel: ObservableObject  {
        
        @Published var shortUrl = ""
        @Published var comments = [Comment]()
        @Published var commentError = false
        @Published var showProgressView = false
        @Published var alertMessage = (title: "", message: "")
        @Published var showAlert = false
        
        let commentSession = CommentService()
        
        func getShortUrl(stringUrl: String?) {
            guard let stringUrl = stringUrl else { return }
            guard let url = URL(string: stringUrl) else { return }
            guard let hostUrl = url.host else { return }
            shortUrl = hostUrl
        }
        
        func getComment(anecdoteId: String) {
            showProgressView = true
            Task {
                do {
                    let retrieveComments = try await commentSession.readComments(anecdoteId: anecdoteId)
                    comments = retrieveComments
                    showProgressView = false
                }
                catch {
                    commentError = true
                    alertMessage = (title: "Erreur", message: "Une erreur s'est produite. Veuillez réessayer ultérieurement et vérifiez votre connexion internet.")
                    showAlert = true
                    showProgressView = false
                }
            }
        }
        
        func save(commentToSave: String, anecdoteId: String, user: FabulaUser?) {
            
            showProgressView = true
            
            guard let user = user else { return }
            
            let commentToSave: [String: Any] = [
                "commentId": UUID().uuidString,
                "commentText": commentToSave,
                "userName": user.userName as Any,
                "userId": user.userId as Any,
                "anecdoteId": anecdoteId,
                "date": Timestamp(date: Date()),
                "userImage": user.userImage?.absoluteString as Any]
            
            commentSession.save(commentToSave: commentToSave) { [weak self] result in
                switch result {
                case.success:
                    self?.getComment(anecdoteId: anecdoteId)
                    self?.showProgressView = false
                case.failure(_):
                    self?.commentError = true
                    self?.alertMessage = (title: "Erreur", message: "Une erreur s'est produite. Veuillez réessayer ultérieurement et vérifiez votre connexion internet.")
                    self?.showAlert = true
                    self?.showProgressView = false
                }
            }
        }
        
        func updateCommentAfterChange(comment: Comment) {
            
            for (index, saveComment) in comments.enumerated() {
                if saveComment.commentId == comment.commentId {
                    DispatchQueue.main.async {
                        self.comments[index] = comment
                    }
                }
            }
        }
        
//        func reportComment(comment: Comment) {
//            
//            showProgressView = true
//            
//            let commentToSave: [String: Any] = [
//                "reportCommentId": comment.commentId,
//                "reportCommentText": comment.commentText,
//                "commentUserId": comment.userId,
//                "commentUserName": comment.userName,
//                "anecdoteId": comment.anecdoteId]
//            
//            commentSession.commentReport(comment: commentToSave) { [weak self] result in
//                switch result {
//                case.success:
//                    self?.showProgressView = false
//                case.failure(_):
//                    self?.commentError = true
//                    self?.alertMessage = (title: "Erreur", message: "Une erreur s'est produite. Veuillez réessayer ultérieurement et vérifiez votre connexion internet.")
//                    self?.showAlert = true
//                    self?.showProgressView = false
//                }
//            }
//        }
    }
}


