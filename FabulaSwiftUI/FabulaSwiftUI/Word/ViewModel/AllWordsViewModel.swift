//
//  WordViewModel.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 28/06/2022.
//

import Foundation

extension AllWordsView {
    
@MainActor class AllWordsViewModel: ObservableObject {
    
    @Published var words = [Word]()
    @Published var favoriteWords = [Word]()
    @Published var isErrorOccured = false
    @Published var pageNumber = 1
    @Published var isNextHidden = false
    @Published var isPreviousHidden = true
    @Published var allWordsList = [WordsForLetter]()
    @Published var isLoading = false

    var wordService = WordService()
    let dataController = DataController.shared

    var cacheWords = WordCache.shared
    
    func selectedWordChanged(selectedCategorie: WordCategoriesMenu) {
        isLoading = true
        switch selectedCategorie {
        case .nouveautes:
            if isWordSaved(selectedCategorie: selectedCategorie) == false {
                getWord()
            }
        case .favoris:
            getAllFav()
        default:
            if allWordsList.isEmpty {
                getAllWordsList()
            } else {
                isLoading = false
            }
        }
    }

    func isWordSaved(selectedCategorie: WordCategoriesMenu) -> Bool {
        guard let wordState = cacheWords.getWordState() else { return false }
        let updatedWords = updateWordFav(words: wordState.words)
        wordState.words = updatedWords
        pageNumber = wordState.page
        setNavButton(numberOfWords: updatedWords.count, wordState: wordState)
        words = updatedWords.count > Constant.dataToPresent ? updatedWords.dropLast() : updatedWords
        isLoading = false
        return true
    }

    func updateWordFav(words: [Word]) -> [Word] {
        dataController.fetchWordFav()
        var newWords = [Word]()
        var newWord: Word

        for index in 0..<words.count {

            let wordIsFav = dataController.savedFavWords.contains { wordFav in
                wordFav.word == words[index].word
            }
            if wordIsFav {
                newWord = words[index]
                newWord.isFavorite = true
                newWords.append(newWord)
            } else {
                newWord = words[index]
                newWord.isFavorite = false
                newWords.append(newWord)
            }
        }
        return newWords
    }

    func selectedCategorieNext(selectedCategorie: WordCategoriesMenu) {
        switch selectedCategorie {
        case.nouveautes:
            getNewWords()
        case.favoris:
            return
        default:
            print("default")
        }
    }

    func selectedCategoriePrevious(selectedCategorie: WordCategoriesMenu) {
        switch selectedCategorie {
        case.nouveautes:
            getPreviousWords()
        case.favoris:
            return
        default:
            getPreviousWords()
        }
    }

    func refresh(filterBy: WordCategoriesMenu) {
        if filterBy == .favoris {
            return
        } else if filterBy == .allWord {
            getAllWordsList()
        }
        else {
            getWord()
        }
    }

    func getWord() {
        Task {
            do {
                let result = try await wordService.getWords()

                if result.words.isEmpty {
                    isErrorOccured = true
                    isLoading = false
                }
                let updatedWords = updateWordFav(words: result.words)

                setNavButton(numberOfWords: updatedWords.count, wordState: nil)

                let wordState = WordState(words: updatedWords, snapshots: result.snapshots, page: 1)

                cacheWords.saveWordState(wordState: wordState)

                pageNumber = 1
                words = updatedWords.count > Constant.dataToPresent ? updatedWords.dropLast() : updatedWords
                isLoading = false
            }
            catch {
                isErrorOccured = true
                isLoading = false
                print("ERREUR")
            }
        }
    }

    func getNewWords() {
        Task {
            do {
                
                guard let currentWordState = cacheWords.getWordState() else { return }
                
                let result = try await wordService.getNewWords(snapshots: currentWordState.snapshots)

                let updatedWords = updateWordFav(words: result.words)

                let wordState = WordState(words: updatedWords, snapshots: result.snapshots, page: currentWordState.page + 1)

                cacheWords.saveWordState(wordState: wordState)
                
                setNavButton(numberOfWords: updatedWords.count, wordState: wordState)
                pageNumber = currentWordState.page + 1
                words = updatedWords.count > Constant.dataToPresent ? updatedWords.dropLast() : updatedWords
                isLoading = false

            } catch {
                isErrorOccured = true
                isLoading = false
                print("Error when try to getNewAnecdotes: \(error.localizedDescription)")
            }
        }
    }

    func getPreviousWords() {

        guard let currentWordState = cacheWords.getWordState() else { return }
        
        Task {
            do {
                let result = try await wordService.getPreviousWords(snapshots: currentWordState.snapshots)

                let updatedWords = updateWordFav(words: result.words)

                let wordState = WordState(words: updatedWords, snapshots: result.snapshots, page: currentWordState.page - 1)
                
                cacheWords.saveWordState(wordState: wordState)

                pageNumber = currentWordState.page - 1

                setNavButton(numberOfWords: updatedWords.count, wordState: wordState)
                words = updatedWords.count > Constant.dataToPresent ? updatedWords.dropLast() : updatedWords
                isLoading = false
            } catch {
                isErrorOccured = true
                isLoading = false
            }
        }
    }

    func setNavButton(numberOfWords: Int, wordState: WordState?)  {

        guard let wordState = wordState else {
            isNextHidden = false
            isPreviousHidden = true
            return
        }
        if wordState.page == 1 {
            isNextHidden = false
            isPreviousHidden = true
        } else {
            if numberOfWords == Constant.numberOfData {
                isNextHidden = false
                isPreviousHidden = false
            } else {
                isNextHidden = true
                isPreviousHidden = false
            }
        }
    }
    
    func getAllWordsList() {
        Task {
        do {
        let list = try await wordService.getAllWords()
            let orderedList = list.sorted()
            let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".map({ String($0) })
            var result = [WordsForLetter()]
            for letter in alphabet {
                let wordsForLetter = WordsForLetter()
                wordsForLetter.letter = letter
                let matches = orderedList.filter({ $0.hasPrefix(letter) })
                wordsForLetter.words = matches
                result.append(wordsForLetter)
            }
            allWordsList = result
            isLoading = false
        } catch {
            isErrorOccured = true
            isLoading = false
            print(error.localizedDescription)
        }
        }
    }

    func getAllFav() {
        Task {
            dataController.fetchWordFav()
            let wordFav = dataController.savedFavWords.map { fav -> Word in
                return Word(word: fav.word ?? "", definition: fav.definition ?? "", qualifier: fav.qualifier ?? "", example: fav.example ?? "", isFavorite: true)
            }
            
            favoriteWords = wordFav
            isLoading = false
//            words = wordFav
        }
    }

}
}
