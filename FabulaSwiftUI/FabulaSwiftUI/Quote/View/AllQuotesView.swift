//
//  AllQuotesView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 12/06/2022.
//

import SwiftUI

struct AllQuotesView: View {
    
    var isFromSettings = false
    
    @State private var selectedCategory = QuoteCategoriesMenu.nouveautes
    @State private var nextIsTapped = false
    @State private var previousIsTapped = false
    @State private var showInterstitialAd = false
    @State private var interstitial = Interstitial()
    
    @StateObject private var viewModel = AllQuotesViewModel()
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            ScrollViewReader { proxy in
                ScrollCategoryView(selectedCategory: $selectedCategory, categoryColor: Color.purple)
                List {
                    Section {
                        if selectedCategory == QuoteCategoriesMenu.favoris && viewModel.quotes.isEmpty {
                            Spacer()
                            LottieView(name: "empty-state", numberOfRepeat: 1, height: 100)
                                .frame(height: 100)
                            Text("Vous n'avez pas de favoris.\nPour ajouter une citation en favoris cliquez sur le coeur.")
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .listRowBackground(Color.background)
                        } else if viewModel.quotes.isEmpty {
                                CustomProgressView()
                        } else {
                            ForEach($viewModel.quotes, id: \.text) { $quote in
                                QuoteView(quote: $quote)
                            }
                            .id("scroll_to_top")
                        }
                    }
                    .listRowBackground(Color.background)
                    .hideRowSeparator()
                }
//                .refreshable(action: {
//                    viewModel.refresh(filterBy: selectedCategory)
//                })
                .padding(.bottom, 30)
                .hideScrollBackground()
                .listStyle(.plain)
                
                .onAppear {
                    selectedCategory = isFromSettings ? .favoris : .nouveautes
                    viewModel.selectedQuoteChanged(selectedCategorie: selectedCategory)
                }
                .onChange(of: selectedCategory) { category in
                    viewModel.selectedQuoteChanged(selectedCategorie: category)
                }
                .onChange(of: nextIsTapped) { _ in
                    viewModel.selectedCategorieNext(selectedCategorie: selectedCategory)
                    withAnimation(.spring()) {
                        proxy.scrollTo("scroll_to_top")
                    }
                }
                .onChange(of: previousIsTapped) { _ in
                    viewModel.selectedCategoriePrevious(selectedCategorie: selectedCategory)
                    if selectedCategory != .favoris {
                        withAnimation(.spring()) {
                            proxy.scrollTo("scroll_to_top")
                        }
                    }
                }
                .alert(isPresented: $viewModel.isErrorOccured) {
                    Alert(title: Text("Erreur"), message: Text("Une erreur s'est produite. Vérifiez votre connexion ou réessayer."), dismissButton: .default(Text("OK")))
                }
            }
            if selectedCategory != .favoris {
                Section {
                    FooterView(nextIsTapped: $nextIsTapped, previousIsTapped: $previousIsTapped, showInterstitialAd: $showInterstitialAd, pageNumber: viewModel.pageNumber, isPreviousHidden: viewModel.isPreviousHidden, isNextHidden: viewModel.isNextHidden)
                        .padding(.horizontal)
                }
            }
        }
        .navigationTitle("Citations")
        
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AllQuotesView_Previews: PreviewProvider {
    static var previews: some View {
        AllQuotesView()
    }
}
