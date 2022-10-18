//
//  SettingsScoreViewModel.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 06/07/2022.
//

import Foundation

class SettingsScoreViewModel: ObservableObject {
    
    @Published var gameScoreByCategory = [String: [GameScore]]()
    @Published var categories =  [String]()
    
    func getGameScores() {
        DataController.shared.fetchGameScore()
        
        var result = [String: [GameScore]]()
        
        for gameScore in DataController.shared.gameScores {
            if result[gameScore.category!] != nil {
                var precedentGameScores = result[gameScore.category!]
                precedentGameScores?.append(gameScore)
                result[gameScore.category!] = precedentGameScores
            } else {
                result[gameScore.category!] = [gameScore]
            }
        }
        
        gameScoreByCategory = result
        
        categories = Array(result.keys)
    }
    
}
