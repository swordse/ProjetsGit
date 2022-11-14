//
//  DataController.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 03/06/2022.
//

import Foundation
import CoreData

class DataController: ObservableObject {

    static let shared = DataController()
    
    let container = NSPersistentContainer(name: "Fabula")
    
    @Published var savedFavAnecdotes: [AnecdoteFav] = []
    @Published var savedFavQuotes: [QuoteFav] = []
    @Published var savedFavWords: [WordFav] = []
    @Published var gameScores: [GameScore] = []
    
    private init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load \(error.localizedDescription)")
        }
    }
    }
    
    // MARK: Anecdote
    func fetchFavAnecdote() {
        let request = NSFetchRequest<AnecdoteFav>(entityName: "AnecdoteFav")
        do {
        savedFavAnecdotes = try container.viewContext.fetch(request)
        }
        catch {
            print("Error when fetch core data: \(error.localizedDescription)")
        }
    }
    
    func addFav(anecdote: Anecdote) {
        
        var date: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        guard let anecdoteDate = anecdote.date else { return "" }
        let date = anecdoteDate.dateValue()
        return formatter.string(from: date)
        }
        
        let favAnecdote = AnecdoteFav(context: container.viewContext)
        favAnecdote.id = anecdote.id
        favAnecdote.category = anecdote.category.rawValue
        favAnecdote.date = date
        favAnecdote.title = anecdote.title
        favAnecdote.source = anecdote.source
        favAnecdote.text = anecdote.text
    
        saveData()
    }
    
    private func saveData() {
        do {
            try container.viewContext.save()
            fetchFavAnecdote()
        }
        catch {
            print("Error saving: \(error.localizedDescription)")
        }
    }
    
    func deleteFav(favAnecdote: AnecdoteFav) {
        container.viewContext.delete(favAnecdote)
        saveData()
    }
    
    func checkIfIsFavorite(anecdote: Anecdote) -> Bool {
        let request = NSFetchRequest<AnecdoteFav>(entityName: "AnecdoteFav")
        guard let id = anecdote.id else { return false }
        request.predicate = NSPredicate(format: "id == %@", id)
        do {
        let result = try container.viewContext.fetch(request)
            if result.isEmpty { return false }
            else { return true }
        }
        catch {
            print("Error when fetch core data: \(error.localizedDescription)")
            return false
        }
    }
    
    //MARK: Quote
    
    func fetchQuoteFav() {
        let request = NSFetchRequest<QuoteFav>(entityName: "QuoteFav")
        do {
        savedFavQuotes = try container.viewContext.fetch(request)
        }
        catch {
            print("Error when fetch core data: \(error.localizedDescription)")
        }
    }
    
    func addQuoteFav(quote: Quote) {
        
        let favQuote = QuoteFav(context: container.viewContext)
        favQuote.category = quote.category.rawValue
        favQuote.author = quote.author
        favQuote.text = quote.text
    
        saveQuoteFav()
    }
    
    private func saveQuoteFav() {
        do {
            try container.viewContext.save()
            fetchQuoteFav()
        }
        catch {
            print("Error saving: \(error.localizedDescription)")
        }
    }
    
    func deleteFav(favQuote: QuoteFav) {
        container.viewContext.delete(favQuote)
        saveQuoteFav()
    }
    
//    func checkIfIsFavorite(quote: Quote) -> Bool {
//        let request = NSFetchRequest<QuoteFav>(entityName: "QuoteFav")
//        request.predicate = NSPredicate(format: "text == %@", quote.text)
//        do {
//        let result = try container.viewContext.fetch(request)
//            if result.isEmpty { return false }
//            else { return true }
//        }
//        catch {
//            print("Error when fetch core data: \(error.localizedDescription)")
//            return false
//        }
//    }
    
    //MARK: Words
    
    func fetchWordFav() {
        let request = NSFetchRequest<WordFav>(entityName: "WordFav")
        do {
        savedFavWords = try container.viewContext.fetch(request)
        }
        catch {
            print("Error when fetch core data: \(error.localizedDescription)")
        }
    }
    
    func addWordFav(word: Word) {
        
        let favWord = WordFav(context: container.viewContext)
        favWord.word = word.word
        favWord.definition = word.definition
        favWord.qualifier = word.qualifier
        favWord.example = word.example
    
        saveWordFav()
    }
    
    private func saveWordFav() {
        do {
            try container.viewContext.save()
            fetchWordFav()
        }
        catch {
            print("Error saving: \(error.localizedDescription)")
        }
    }
    
    func deleteFav(favWord: WordFav) {
        container.viewContext.delete(favWord)
        saveWordFav()
    }
    
    //MARK: Score
    
    func fetchGameScore() {
        let request = NSFetchRequest<GameScore>(entityName: "GameScore")
        do {
        gameScores = try container.viewContext.fetch(request)
        }
        catch {
            print("Error when fetch core data gameScore: \(error.localizedDescription)")
        }
    }
    
    func createGameScore(category: String, theme: String, score: Int16) {
        
        fetchGameScore()
        if let savedGameScore = findTheme(theme: theme) {
            deleteGameScore(gameScore: savedGameScore)
        }
        
        let gameScore = GameScore(context: container.viewContext)
        gameScore.score = score
        gameScore.theme = theme
        gameScore.category = category
    
        saveGameScore()
    }
    
    private func saveGameScore() {
        do {
            try container.viewContext.save()
            fetchGameScore()
        }
        catch {
            print("Error saving: \(error.localizedDescription)")
        }
    }
    
    private func deleteGameScore(gameScore: GameScore) {
        container.viewContext.delete(gameScore)
        saveGameScore()
    }

    private func findTheme(theme: String) -> GameScore? {
        
        if gameScores.isEmpty { return nil }
        
        for gameScore in gameScores {
            if gameScore.theme == theme {
                return gameScore
            }
        }
        return nil
    }
    
}

