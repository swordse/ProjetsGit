//
//  SettingsScoreView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 06/07/2022.
//

import SwiftUI

struct SettingsScoreView: View {
    
    @StateObject var viewModel = SettingsScoreViewModel()
    
    var body: some View {
        
        ZStack {
            Color.background
                .ignoresSafeArea()
            if viewModel.gameScoreByCategory.isEmpty {
                Text("Vous n'avez pour l'instant aucun score.\nFinissez des quizzs pour voir tous vos scores ici.")
                    .multilineTextAlignment(.center)
                    .padding()
                    .padding(.bottom, 60)
            }
            else {
                Form {
                    ForEach(viewModel.categories, id: \.self) { category in
                        Section {
                            ForEach(viewModel.gameScoreByCategory[category]!, id: \.theme) { gameScore in
                                VStack {
                                    HStack {
                                        Text("\(gameScore.theme!):")
                                        Spacer()
                                        Text("\(gameScore.score)/10")
                                    }
                                    ProgressView(value: Double(gameScore.score), total: 10)
                                }
                            }
                        } header: {
                            Text(category.uppercased())
                        }
                        .listRowBackground(Color.lightBackground)
                    }
                    .listRowBackground(Color.lightBackground)
                }
                .hideScrollBackground()
                .navigationTitle("Scores")
            }
        }.navigationViewStyle(.stack)
            .onAppear {
                viewModel.getGameScores()
            }
    }
}

struct SettingsScoreView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScoreView()
    }
}
