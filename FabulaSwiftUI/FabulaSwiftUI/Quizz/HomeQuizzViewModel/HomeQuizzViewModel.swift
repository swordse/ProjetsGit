//
//  HomeQuizzViewModel.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 30/06/2022.
//

import Foundation
import SwiftUI

enum JsonData: String {
    case categories
    case quizzs
    
    var string: String {
        switch self {
        case .categories: return "categories.json"
        case .quizzs: return "quizzs.json"
        }
    }
}

extension HomeQuizzView {
    
    @MainActor class HomeQuizzViewModel: ObservableObject {
        
        var quizzService = QuizzService()
        var categoriesName = [String]()
        var themeNames = [String: [String]]()
        var jsonThemes: Set<String> = []
        
        internal init(quizzService: QuizzService = QuizzService(), categoriesName: [String] = [String](), themeNames: [String : [String]] = [String: [String]](), jsonThemes: Set<String> = []) {
            self.quizzService = quizzService
            self.categoriesName = categoriesName
            self.themeNames = themeNames
            self.jsonThemes = jsonThemes
        }
        
        //MARK: - Output
        // categories contains data for the first row with image and category name
        @Published var categories = [QuizzCategoryInfo]()
        // theme contains name of each quizz by category
        @Published var theme = [String: [String]]()
        @Published var gameScores = [GameScore]()
        @Published var networkError = false
        @Published var quizzs = [Quizz]()
        @Published var errorOccured = false
        
        //    MARK: - Methods
        // retrieve category from FireStore for HomeQuizz
        func retrieveCategory() {
            retrieveGameScore()
            
            guard categories.isEmpty else { return }
            // get category from JSON
            getJsonData()
            // get category from Firebase
            quizzService.getCategoryQuizz { [weak self] result in
                switch result {
                case.failure(_):
                    // if failure loading from network, use data from JSON
                    self?.theme = self?.themeNames ?? [:]
                    self?.getCategoryInfo(category: self?.categoriesName ?? [])
                    self?.errorOccured = true
                case.success(let success):
                    if success.isEmpty {
                        self?.errorOccured = true
                    }
                    for i in 0 ..< success.count {
                        for (key, value) in success[i] {
                            self?.themeNames[key]?.append(contentsOf: value as! [String])
                        }
                    }
                    self?.getCategoryInfo(category: self?.categoriesName ?? [])
                    self?.theme = self?.themeNames ?? [:]
                }
            }
            
        }
        
        // retrieve category and theme from Json Files
        func getJsonData() {
            let categorieTitle: CategorieTitle = Bundle.main.decode(JsonData.categories.string)
            for categorie in categorieTitle.categories {
                let themeName = categorie.categorieName
                categoriesName.append(themeName)
                for theme in categorie.themes {
                    jsonThemes.insert(theme)
                }
                themeNames[categorie.categorieName] = categorie.themes
            }
        }
        
        // based on category name, create a QuizzCategoryInfo to have requested info to display (color, image...)
        func getCategoryInfo(category: [String]) {
            var quizzCategoryInfo: QuizzCategoryInfo?
            var quizzCategoryInfos = [QuizzCategoryInfo]()
            for item in category {
                let quizzCategory = QuizzCategory(rawValue: item)
                switch quizzCategory {
                case.histoire:
                    quizzCategoryInfo = QuizzCategoryInfo(name: item, image: Image("Histoire"), color: Color("red"))
                case.science:
                    quizzCategoryInfo = QuizzCategoryInfo(name: item, image: Image("Science"), color: Color( "blue"))
                case.litterature:
                    quizzCategoryInfo = QuizzCategoryInfo(name: item, image: Image("Littérature"), color: Color("pink"))
                case.art:
                    quizzCategoryInfo = QuizzCategoryInfo(name: item, image: Image("Art"), color: Color("green"))
                case .loisirs:
                    quizzCategoryInfo = QuizzCategoryInfo(name: item, image: Image("Loisirs"), color: Color("loisirs"))
                case .nature:
                    quizzCategoryInfo = QuizzCategoryInfo(name: item, image: Image("Nature"), color: Color("nature"))
                case .geographie:
                    quizzCategoryInfo = QuizzCategoryInfo(name: item, image: Image("Géographie"), color: Color("géographie"))
                case .sport:
                    quizzCategoryInfo = QuizzCategoryInfo(name: item, image: Image("Sport"), color: Color("sport"))
                    
                case .none:
                    print("no category")
                }
                guard let quizzCategoryInfo = quizzCategoryInfo else { return }
                quizzCategoryInfos.append(quizzCategoryInfo)
            }
            categories = quizzCategoryInfos
        }
        
        //  retrieve quizz for TestQuizz
        func retrieveQuizz(theme: String) {
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
                    self.quizzs = quizzs
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
        }
        
        // retrieve game score to show in the theme button
        func retrieveGameScore() {
            DataController.shared.fetchGameScore()
            gameScores = DataController.shared.gameScores
        }
        
    }
}
