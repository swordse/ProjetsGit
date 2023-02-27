//
//  FavoritesView.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 19/01/2023.
//

import SwiftUI

struct FavoritesView: View {
    @Environment(\.dismiss) var dismiss
    @FetchRequest(sortDescriptors: []) var favAnecdotes: FetchedResults<FavAnecdote>
    
    init() {
            UITableView.appearance().backgroundColor = UIColor(named: "cellBackground")
        }
    
    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea()
            if favAnecdotes.isEmpty {
                MessageView(title: "Vous n'avez pas encore de favoris", message: "Pour ajouter une anecdote en favoris, cliquez sur le coeur dans le détail d'un anecdote.", content: { })
                    .padding(.horizontal)
//                    Text("Vous n'avez pas encore de favoris.")
//                        .multilineTextAlignment(.center)
//                        .padding()
            } else {
                List {
                    ForEach(favAnecdotes, id: \.self) { fav in
                        NavigationLink {
                            ScrollView {
                                DetailAnecdoteView(anecdote: Anecdote(id: fav.id ?? "", category: Anecdote.Category(rawValue: fav.category ?? "") ?? .inclassable, title: fav.title ?? "", text: fav.text ?? "", source: fav.source ?? "", index: 0))
                                    
                            }
                            .background(Color("cellBackground"))
                        } label: {
                            SimpleAnecdoteView(anecdote: Anecdote(id: fav.id ?? "", category: Anecdote.Category(rawValue: fav.category ?? "") ?? .inclassable, title: fav.title ?? "", text: fav.text ?? "", source: fav.source ?? "", index: 0))
                        }
                        .background(Color("cellBackground"))
                    }
                    .listRowBackground(Color("cellBackground"))
                    .background(Color("cellBackground"))
                    .listRowSeparator(.hidden)
                }
                .hideScrollBackground()
                
            }
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
