//
//  AllWordsView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 28/06/2022.
//

import SwiftUI

struct AllWordsView: View {
    
    var isFromSettings = false
    
    @State private var selectedCategory = WordCategoriesMenu.nouveautes
    
    @State private var nextIsTapped = false
    @State private var previousIsTapped = false
    @State private var showInterstitialAd = false
    @State private var interstitial = Interstitial()
    
    @StateObject private var viewModel = AllWordsViewModel()
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            ScrollViewReader { proxy in
                ScrollCategoryView(selectedCategory: $selectedCategory, categoryColor: Color.blue)
                List {
                    if viewModel.isLoading {
                        CustomProgressView()
                            .listRowBackground(Color.background)
                    } else {
                        Section {
                            if selectedCategory == WordCategoriesMenu.favoris {
                                if viewModel.favoriteWords.isEmpty {
                                    Spacer()
                                    LottieView(name: "empty-state", numberOfRepeat: 1, height: 100)
                                        .frame(height: 100)
                                    Text("Vous n'avez pas de favoris.\nPour ajouter un mot dans vos favoris cliquez sur le coeur.")
                                        .multilineTextAlignment(.center)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .listRowBackground(Color.background)
                                } else {
                                    ForEach($viewModel.favoriteWords, id: \.word) { $word in
                                        WordView(word: $word)
                                    }
                                    .listRowBackground(Color.background)
                                }
                            }
                            else if selectedCategory == WordCategoriesMenu.allWord {
                                ForEach($viewModel.allWordsList, id: \.letter) { $wordsForLetter in
                                    Section {
                                        ForEach($wordsForLetter.words, id: \.self) { $word in
                                            NavigationLink {
                                                SingleWordView(wordString: $word)
                                            } label: {
                                                Text(word)
                                                    .padding(.leading)
                                            }
                                        }
                                    } header: {
                                        Text(wordsForLetter.letter)
                                            .font(.headline)
                                            .fontWeight(.bold)
                                    }
                                }
                            } else {
                                ForEach($viewModel.words, id: \.word) { $word in
                                    WordView(word: $word)
                                }
                                .id("scroll_to_top")
                                .listRowBackground(Color.background)
                            }
                        }
                        .listRowBackground(Color.background)
                        .hideRowSeparator()
                    }
                }
                .refreshView(action: {
                    await viewModel.refresh(filterBy: selectedCategory)
                })
                .padding(.bottom, 30)
                .hideScrollBackground()
                .listStyle(.plain)
                .onAppear {
                    if isFromSettings {
                        selectedCategory = .favoris
                    }
                    else {
                        viewModel.selectedWordChanged(selectedCategorie: selectedCategory)
                    }
                }
                .onChange(of: selectedCategory) { category in
                    viewModel.selectedWordChanged(selectedCategorie: category)
                }
                .onChange(of: nextIsTapped) { _ in
                    viewModel.selectedCategorieNext(selectedCategorie: selectedCategory)
                    withAnimation(.spring()) {
                        proxy.scrollTo("scroll_to_top")
                    }
                }
                .onChange(of: previousIsTapped) { _ in
                    viewModel.selectedCategoriePrevious(selectedCategorie: selectedCategory)
                    withAnimation(.spring()) {
                        proxy.scrollTo("scroll_to_top")
                    }
                }
                .onChange(of: showInterstitialAd) { newValue in
                    withAnimation {
                        interstitial.showAd()
                    }
                }
                .alert(isPresented: $viewModel.isErrorOccured) {
                    Alert(title: Text("Une erreur est survenue"), message: Text("Une erreur s'est produite. Vérifiez votre connexion ou réessayer."), dismissButton: .default(Text("OK")))
                }
            }
            if !viewModel.words.isEmpty && selectedCategory == .nouveautes {
                FooterView(nextIsTapped: $nextIsTapped, previousIsTapped: $previousIsTapped, showInterstitialAd: $showInterstitialAd, pageNumber: viewModel.pageNumber, isPreviousHidden: viewModel.isPreviousHidden, isNextHidden: viewModel.isNextHidden)
                    .padding(.horizontal)
            }
        }
        .navigationTitle("Mots du jour")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AllWordsView_Previews: PreviewProvider {
    static var previews: some View {
        AllWordsView()
    }
}
