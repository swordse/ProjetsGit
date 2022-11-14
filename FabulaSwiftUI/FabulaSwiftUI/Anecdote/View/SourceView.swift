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
    @State private var showWeb = false
    
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
                if let url = URL(string: stringUrl) {
                    UIApplication.shared.open(url)
                } else {
                    if let validString = stringUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed), let url = URL(string: validString) {
                        UIApplication.shared.open(url)
                    }
                }
                
            } label: {
                Text(getShortUrl(stringUrl: anecdote.source))
                    .foregroundColor(.blue)
            }.buttonStyle(PlainButtonStyle())
        }.padding(.top, 5)
            .padding(.bottom, 5)
        
    }
    
    func getShortUrl(stringUrl: String?) -> String {
        var result = ""
        
        if let url = URL(string: stringUrl!) {
            guard let hostUrl = url.host else { return ""}
            result = hostUrl
        } else {
            if let validString = stringUrl!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed), let url = URL(string: validString) {
                guard let hostUrl = url.host else { return ""}
                result = hostUrl
            }
        }
        return result
    }
}

struct SourceView_Previews: PreviewProvider {
    static var previews: some View {
        
        SourceView(anecdote: Anecdote(category: .arts, title: "L'histoire est amusante", text: "Il faut que j'écrive du texte pour remplir le placeholder dans le seul but de voir le résultat final. Il ne s'agit ici bien évidemment pas d'une anecdote à part entière.", date: Timestamp(seconds: 1643151600, nanoseconds: 0), isFavorite: false), viewModel: DetailAnecdoteView.DetailAnecdoteViewModel())
    }
}
