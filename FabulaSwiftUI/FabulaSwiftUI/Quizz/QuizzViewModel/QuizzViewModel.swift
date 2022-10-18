//
//  QuizzViewModel.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 04/07/2022.
//

import Foundation

extension QuizzView {

@MainActor class QuizzViewModel: ObservableObject {
    
    var quizzService = QuizzService()
    var theme = ""
    var category = ""
    var jsonThemes: Set<String> = []
    var correctAnswer = ""
    var questionNumber = 0
    
    @Published var propositions = [String]()
    @Published var question = ""
    @Published var isCorrect = false
    @Published var displayedScore = 0
    @Published var isOngoing = true
    @Published var errorOccured = false
    @Published var quizzs = [Quizz]()
    @Published var buttonIsDisabled = false
    @Published var playerResponses = [String]()
    
    //    MARK: - Methods
    // call to start new game or if the game is ongoing
    func setUpQuizz() {
        if isOngoing {
        propositions = quizzs[questionNumber].propositions
        question = quizzs[questionNumber].question
        correctAnswer = quizzs[questionNumber].answer
        }
    }
    // check if answer is correct
    func isCorrect(playerResponse: String) {
        if playerResponse == correctAnswer {
            displayedScore += 1
        }
        playerResponses.append(playerResponse)
    }

    func nextQuestion() {
        questionNumber += 1
        if questionNumber < quizzs.count {
            setUpQuizz()
        } else {
            endGame()
        }
    }
    
    func toggleButtonIsDisabled() {
        buttonIsDisabled.toggle()
    }
    
    func endGame() {
        let theme = theme
        DataController.shared.createGameScore(category: category, theme: theme, score: Int16(displayedScore))
        isOngoing.toggle()
    }
    
    func restartGame() {
        isOngoing = true
        questionNumber = 0
        displayedScore = 0
        setUpQuizz()
    }
    
    func getJsonData() {
        let categorieTitle: CategorieTitle = Bundle.main.decode(JsonData.categories.string)
        for categorie in categorieTitle.categories {
            for theme in categorie.themes {
                jsonThemes.insert(theme)
            }
        }
    }
    
    func retrieveQuizz(theme: String) {
        getJsonData()
        if jsonThemes.contains(theme) {
            retrieveJsonQuizz(theme: theme)
        } else {
            getQuizzsFireStore(theme: theme)
        }
    }
    
    func getQuizzsFireStore(theme: String)  {
        Task { () -> [Quizz] in
            do {
                let result = try await quizzService.getQuizzs(title: theme)
                guard let quizzs = result.0 else { return [] }
                if quizzs.isEmpty {
                    errorOccured = true
                }
                self.quizzs = quizzs
                setUpQuizz()
            } catch {
                errorOccured = true
            }
            return quizzs
        }
    }
    
    // retrieve quizz for specific theme in JSON file
    func retrieveJsonQuizz(theme: String) {
        let allQuizzs: [String: AllQuizzs] = Bundle.main.decode(JsonData.quizzs.string)
        guard let quizzs = allQuizzs[theme]?.quizzs else { return }
        self.quizzs = quizzs
        setUpQuizz()
    }
}
}
