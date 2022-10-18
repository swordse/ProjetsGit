//
//  SourceView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 02/06/2022.
//

import SwiftUI
import Firebase

struct SourceView: View {
    
    let anecdote: Anecdote
    let viewModel: DetailAnecdoteView.DetailAnecdoteViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .firstTextBaseline) {
                Image(systemName: "book.closed")
                Text("Source:")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            Spacer()
            
            Button {
                guard let stringUrl = anecdote.source else { return }
                guard let url = URL(string: stringUrl) else { return }
                UIApplication.shared.open(url)
            } label: {
                Text(getShortUrl(stringUrl: anecdote.source))
                    .foregroundColor(.blue)
            }.buttonStyle(PlainButtonStyle())
        }.padding(.top, 5)
            .padding(.bottom, 5)
    }
    
    func getShortUrl(stringUrl: String?) -> String {
        guard stringUrl != nil else { return ""}
        guard let url = URL(string: stringUrl!) else { return ""}
        guard let hostUrl = url.host else { return ""}
        return hostUrl
    }
}

struct SourceView_Previews: PreviewProvider {
    static var previews: some View {
        
        SourceView(anecdote: Anecdote(category: .arts, title: "L'histoire est amusante", text: "Il faut que j'écrive du texte pour remplir le placeholder dans le seul but de voir le résultat final. Il ne s'agit ici bien évidemment pas d'une anecdote à part entière.", date: Timestamp(seconds: 1643151600, nanoseconds: 0), isFavorite: false), viewModel: DetailAnecdoteView.DetailAnecdoteViewModel())
    }
}
