//
//  FavorisViewModel.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 11/07/2022.


import Foundation

@MainActor class FavorisViewModel: ObservableObject {
    
    @Published var anecdoteFav = [Anecdote]()
    @Published var quoteFav = [Quote]()
    @Published var wordFav = [Word]()
    @Published var title = ""
    
    let dataController = DataController.shared
    
    func getFavoritesForSettings(for destination: Destination) {
        switch destination {
//        case .toRGPD:
//            return
        case.toLegal:
            return
        case .toChangePhoto:
            return
        case .toDeleteAccount:
            return
        case .toReview:
            return
        case .toAnecdoteFav:
            dataController.fetchFavAnecdote()
            anecdoteFav = DataController.shared.savedFavAnecdotes.map({ anecdoteFav in
                Anecdote(id: anecdoteFav.id ?? "",category: Anecdote.Category(rawValue: anecdoteFav.category ?? "") ?? .arts, title: anecdoteFav.title ?? "", text: anecdoteFav.text ?? "", source: anecdoteFav.source ?? "" , isFavorite: true)
            })
            title = "Anecdote Favoris"
        case .toCitationFav:
            dataController.fetchQuoteFav()
            quoteFav = DataController.shared.savedFavQuotes.map({ quote in
                Quote(author: quote.author ?? "", text: quote.text ?? "", category: Quote.Category(rawValue: quote.category ?? "") ?? .absurde, isFavorite: true)
            })
            title = "Citation Favoris"
        case .toMotduJourFav:
            dataController.fetchWordFav()
            wordFav = DataController.shared.savedFavWords.map { word in
                Word(word: word.word ?? "", definition: word.definition ?? "", qualifier: word.qualifier ?? "", example: word.example ?? "", isFavorite: true)
            }
            title = "Mot du jour Favoris"
        case .toScores:
            return
//        case .toSubmitRules:
//            return
//        case .toCommentRules:
//            return
//        case .toCGU:
//            return
        case .toEmail:
            return
        }
    }
    
}
