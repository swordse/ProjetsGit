//
//  FavorisView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 11/07/2022.
//

import SwiftUI

enum FavoriteEnum {
    case quoteFav
    case anecdoteFav
    case wordFav
}

struct FavorisView: View {
    
    var toDestination: Destination
    
    @StateObject private var viewModel = FavorisViewModel()

    @State private var userAccountIsPresented = false
    
    var body: some View {
        
        ZStack {
            Color.background
                .ignoresSafeArea()
            List {
                switch toDestination {
                case .toEmail:
                    EmptyView()
                case .toRGPD:
                    EmptyView()
                case .toCGU:
                    EmptyView()
                case .toCommentRules:
                    EmptyView()
                case .toChangePhoto:
                    EmptyView()
                case .toDeleteAccount:
                    EmptyView()
                case .toReview:
                    EmptyView()
                case .toScores:
                    EmptyView()
                case .toSubmitRules:
                    EmptyView()
                case .toAnecdoteFav:
                    Section {
                    if viewModel.anecdoteFav.isEmpty {
                        Spacer()
                        Text("Vous n'avez pas de favoris.\nPour ajouter une anecdote en favoris cliquez sur le coeur dans le détail.")
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(.white)
                            .background(Color.background)
                            .listRowBackground(Color.background)
                    } else {
                        ForEach($viewModel.anecdoteFav) { $anecdote in
                            NavigationLink {
                                DetailAnecdoteView(anecdote: $anecdote)
                            } label: {
                                AnecdoteView(isLineLimit: true, isDetail: false, anecdote: anecdote)
                            }
                        }
                    }
                    }
                    .listRowBackground(Color.background)
                    .hideRowSeparator()
                case .toCitationFav:
                    Section {
                    if viewModel.quoteFav.isEmpty {
                        Spacer()
                        Text("Vous n'avez pas de favoris.\nPour ajouter une citation en favoris cliquez sur le coeur sous la citation.")
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(.white)
                            .background(Color.background)
                    } else {
                        ForEach($viewModel.quoteFav, id: \.text) { $quote in
                            QuoteView(quote: $quote)
                        }
                        .listStyle(.plain)
                        .listRowBackground(Color.background)
                    }
                    }
                    .listRowBackground(Color.background)
                    .hideRowSeparator()
                case .toMotduJourFav:
                    Section {
                    if viewModel.wordFav.isEmpty {
                        Spacer()
                        Text("Vous n'avez pas de favoris.\nPour ajouter un mot en favoris cliquez sur le coeur sous la définition du mot.")
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(.white)
                            .background(Color.background)
                    } else {
                        ForEach($viewModel.wordFav, id: \.word) { $word in
                            WordView(word: $word)
                        }
                    }
                    }.listRowBackground(Color.background)
                        .hideRowSeparator()
                }
            }
            .hideScrollBackground()
            .navigationTitle(viewModel.title)
            .navigationBarTitleDisplayMode(.inline)
            
            .listStyle(.plain)
            .onAppear() {
                viewModel.getFavoritesForSettings(for: toDestination)
            }
            .sheet(isPresented: $userAccountIsPresented, content: {
                AccountView()
            })
        }
    }
}

struct FavorisView_Previews: PreviewProvider {
    static var previews: some View {
        FavorisView(toDestination: .toAnecdoteFav)
    }
}
