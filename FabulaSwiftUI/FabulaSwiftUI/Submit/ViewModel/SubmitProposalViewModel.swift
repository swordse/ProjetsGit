//
//  SubmitProposalViewModel.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 23/06/2022.
//

import Foundation
import SwiftUI
import Combine

enum SelectedCategory: String, CaseIterable {
    case Anecdote = "Anecdote"
    case Citation = "Citation"
    case MotDuJour = "Mot du jour"
}

extension SubmitProposalView {

@MainActor class SubmitProposalViewModel: ObservableObject {
    var categories = ["Anecdote", "Citation", "Mot du jour"]
    
    @Published var selectedCategory = SelectedCategory.Anecdote
    @Published var source = ""
    @Published var anecdote = ""
    @Published var author = ""
    @Published var quote = ""
    @Published var word = ""
    @Published var definition = ""
    
    @Published var alertMessage = (title: "Titre", message: "Message")
    @Published var showAlert = false
    
    @Published var buttonIsDisable = true
//    @Published var isSourceEmpty = true
//    @Published var isAnecdoteEmpty = true
//    @Published var isAuthorEmpty = true
//    @Published var isQuoteEmpty = true
//    @Published var isWordEmpty = true
//    @Published var isDefinitionEmpty = true
   
    private var cancellableSet: Set<AnyCancellable> = []
    let submitSession = FireProposalService()
    
    init() {
        Publishers.CombineLatest($source, $anecdote)
            .receive(on: RunLoop.main)
            .map { (source, anecdote) in
                if !source.isEmpty && !anecdote.isEmpty {
                    return false
                } else {
                    return true
                }
            }
            .assign(to: \.buttonIsDisable, on: self)
            .store(in: &cancellableSet)
    }
    
    func updateButtonState() {
        
        buttonIsDisable = false
        
        switch selectedCategory {
        case .Anecdote:
            Publishers.CombineLatest($source, $anecdote)
                .receive(on: RunLoop.main)
                .map { (source, anecdote) -> Bool in
                    if !source.isEmpty && !anecdote.isEmpty {
                        return false
                    } else {
                        return true
                    }
                }
                .assign(to: \.buttonIsDisable, on: self)
                .store(in: &cancellableSet)
        case .Citation:
            Publishers.CombineLatest($author, $quote)
                .receive(on: RunLoop.main)
                .map { (author, quote) in
                    if !author.isEmpty && !quote.isEmpty {
                        return false
                    } else {
                        return true
                    }
                }
                .assign(to: \.buttonIsDisable, on: self)
                .store(in: &cancellableSet)
        case .MotDuJour:
            Publishers.CombineLatest($word, $definition)
                .receive(on: RunLoop.main)
                .map { (word, definition) in
                    if !word.isEmpty && !definition.isEmpty {
                        return false
                    } else {
                        return true
                    }
                }
                .assign(to: \.buttonIsDisable, on: self)
                .store(in: &cancellableSet)
        }
    }
    
    func saveProposal() {
        
        guard let user = UserDefaultsManager.manager.retrieveCurrentUser() else {
            showAlert = true
            alertMessage = (title: "Connectez-vous", message: "Connectez-vous pour soumettre.")
            return }
        
        let userName = user.userName
        let userEmail = user.userEmail
        let userId = user.userId
        
        let data : [String: Any] = ["category": selectedCategory.rawValue, "source": source, "anecdote": anecdote, "author": author as Any, "quote": quote, "word": word, "definition": definition, "userId": userId as Any, "userName": userName as Any, "userEmail": userEmail as Any]
        
        submitSession.saveProposal(data: data) { error in
            guard error == nil else {
                self.showAlert = true
                self.alertMessage = (title: "Erreur", message: "Une erreur est survenue. Merci de réessayer.")
                return }
            self.showAlert = true
            self.alertMessage = (title: "Merci", message: "Votre proposition a bien été soumise.")
            self.source = ""
            self.anecdote = ""
            self.author = ""
            self.quote = ""
            self.word = ""
            self.definition = ""
        }
    }
}
}
