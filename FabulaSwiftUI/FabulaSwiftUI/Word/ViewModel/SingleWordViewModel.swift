//
//  SingleWordViewModel.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 29/06/2022.
//

import Foundation

extension SingleWordView {
    
    @MainActor final class SingleWordViewModel: ObservableObject {
        
        @Published var specificWord = Word()
        @Published var errorOccured = false
        
        let service = WordService()
        let dataController = DataController.shared
        
        func getSpecificWord(word: String) {
            Task {
                do {
                    let word = try await service.getSpecificWord(word: word)
                    updateWordFav(word: word)
                } catch NetworkError.errorOccured {
                    errorOccured = true
                } catch {
                    errorOccured = true
                }
            }
        }
        
        private func updateWordFav(word: Word) {
            dataController.fetchWordFav()
            
            var newWord = word
            
            let wordIsFav = dataController.savedFavWords.contains { wordFav in
                wordFav.word == word.word
            }
            if wordIsFav {
                newWord.isFavorite = true
                specificWord = newWord
            } else {
                newWord.isFavorite = false
                specificWord = newWord
            }
        }
    }
}
