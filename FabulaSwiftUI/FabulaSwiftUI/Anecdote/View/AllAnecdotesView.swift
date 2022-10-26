//
//  AllAnecdotesView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 01/06/2022.
//

import SwiftUI
import GoogleMobileAds

struct AllAnecdotesView: View {
    
    var isFromSettings = false
    
    @StateObject private var viewModel = AllAnecdotesViewModel()
    @State private var selectedCategory =
    Anecdote.Category.nouveautes
    @State private var previousIsTapped = false
    @State private var nextIsTapped = false
    @State private var showInterstitialAd = false
    @State private var interstitial = Interstitial()
    
    var body: some View {
        
        ZStack {
            Color.background
                .ignoresSafeArea()
            ScrollViewReader { proxy in
                ScrollCategoryView(selectedCategory: $selectedCategory, categoryColor: Color.pink)

                    List {
                        if viewModel.isLoading {
                            CustomProgressView()
                                .listRowBackground(Color.background)
                        } else {
                            Section(content: {
                                if selectedCategory == Anecdote.Category.favoris && viewModel.anecdotes.isEmpty {
                                    Spacer()
                                    LottieView(name: "empty-state", numberOfRepeat: 1, height: 100)
                                        .frame(height: 100)
                                    Text("Vous n'avez pas de favoris.\nPour ajouter une anecdote en favoris cliquez sur le coeur dans le détail.")
                                        .multilineTextAlignment(.center)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .foregroundColor(.white)
                                    Spacer()
                                } else {
                                    ForEach($viewModel.anecdotes) { $anecdote in
                                        if anecdote.title == "" {
                                            BannerAd(unitID: "ca-app-pub-3940256099942544/2934735716")
                                        } else {
                                            
                                            NavigationLink {
                                                NavigationLazyView(DetailAnecdoteView(anecdote: $anecdote))
                                            } label: {
                                                AnecdoteView(isLineLimit: true, isDetail: false, anecdote: anecdote)
                                            }
                                        }
                                    }.id("scroll_to_top")
                                }
                            }
                            )
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
                    .onAppear() {
                        viewModel.selectedCategorieChanged(selectedCategorie: selectedCategory)
                    }
                    .onChange(of: selectedCategory, perform: {  newCategory in
                        viewModel.selectedCategorieChanged(selectedCategorie: newCategory)
                    })
                    .onChange(of: previousIsTapped, perform: { _ in
                        withAnimation(.spring()) {
                            proxy.scrollTo("scroll_to_top")
                        }
                        viewModel.selectedCategoriePrevious(selectedCategorie: selectedCategory)
                    })
                    .onChange(of: nextIsTapped) { _ in
                        withAnimation(.spring()) {
                            proxy.scrollTo("scroll_to_top")
                        }
                        viewModel.selectedCategorieNext(selectedCategorie: selectedCategory)
                    }
                    .alert(isPresented: $viewModel.isErrorOccured) {
                        Alert(title: Text("Erreur"), message: Text("Une erreur s'est produite. Vérifiez votre connexion ou réessayer."), dismissButton: .default(Text("OK")))
                    }
                
            }
            if selectedCategory != .favoris && !viewModel.anecdotes.isEmpty {
                FooterView(nextIsTapped: $nextIsTapped, previousIsTapped: $previousIsTapped, showInterstitialAd: $showInterstitialAd, pageNumber: viewModel.pageNumber, isPreviousHidden: viewModel.isPreviousHidden, isNextHidden: viewModel.isNextHidden)
                    .padding(.horizontal)
            }
        }
        .navigationTitle("Anecdotes")
        .navigationBarTitleDisplayMode(.inline)
        .navigationViewStyle(.stack)
        .onChange(of: showInterstitialAd) { newValue in
            withAnimation {
                interstitial.showAd()
            }
        }
    }
}

struct AllAnecdotesView_Previews: PreviewProvider {
    static var previews: some View {
        AllAnecdotesView()
            .environment(\.colorScheme, .dark)
    }
}
