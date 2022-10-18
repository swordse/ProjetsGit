//
//  AnecdoteView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 01/06/2022.
//

import SwiftUI
import Firebase

struct AnecdoteView: View {
    
    var dataController = DataController.shared
    var isLineLimit: Bool
    var isDetail: Bool
    
    @State private var isShareSheetPresented = false
    @State var anecdote: Anecdote
    
    var body: some View {
            LazyVStack {
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading) {
                        Text(anecdote.title)
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding([.top, .bottom], 5)
                        Rectangle()
                            .frame(width: 60,height: 0.5, alignment: .leading)
                            .foregroundColor(.pink)
                        Text(anecdote.category.rawValue)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 5)
                    }
                    Spacer()
                    if isDetail{
                        Button {
                            anecdote.isFavorite.toggle()
                            favButtonTapped(anecdote: anecdote)
                        } label: {
                            Image(systemName: anecdote.isFavorite ? "suit.heart.fill" : "suit.heart")
                        }
                        .buttonStyle(PlainButtonStyle())
                        .onAppear {
                            anecdote.isFavorite = checkIfIsFavorite(anecdote: anecdote)
                        }
                    } else {
                        Text(anecdote.date != nil ?
                             anecdote.date!.transformTimeStampToString() : "")
                        .font(.caption)
                        .foregroundColor(.primary)
                        .padding([.top, .bottom], 5)
                    }
                }
                Text(anecdote.text
                    .replacingOccurrences(of: "\\n", with: "\n"))
                    .font(Font.system(.headline))
                    .fontWeight(.regular)
                    .lineLimit(isLineLimit ? 5 : nil)
                    .lineSpacing(5)
                    .foregroundColor(.primary)
                    .padding(.top, 5)
                    .padding(.bottom, 20)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .sheet(isPresented: $isShareSheetPresented) {
                ShareSheetView(activityItems: ["Voici une anecdote que j'ai trouvé sur l'application Fabula: \n\(anecdote.text)"])
            }
    }
    
    func favButtonTapped(anecdote: Anecdote) {
        if anecdote.isFavorite {
            dataController.addFav(anecdote: anecdote)
        } else {
            dataController.fetchFavAnecdote()
            let saveFav = dataController.savedFavAnecdotes.first { anecdoteFav in
                anecdoteFav.id == anecdote.id
            }
            if saveFav != nil {
                dataController.deleteFav(favAnecdote: saveFav!)
            }
        }
    }
    
    func checkIfIsFavorite(anecdote: Anecdote) -> Bool {
        
        return dataController.checkIfIsFavorite(anecdote: anecdote)
    }
}

struct AnecdoteView_Previews: PreviewProvider {
    static var previews: some View {
        AnecdoteView(isLineLimit: true, isDetail: true, anecdote: Anecdote(category: .arts, title: "L'histoire est amusante", text: "Il faut que j'écrive du texte pour remplir le placeholder dans le seul but de voir le résultat final. Il ne s'agit ici bien évidemment pas d'une anecdote à part entière.", date: Timestamp(seconds: 1643151600, nanoseconds: 0), isFavorite: false))
    }
}
