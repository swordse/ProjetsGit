//
//  WordView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 28/06/2022.
//

import SwiftUI

struct WordView: View {
    
    let dataController = DataController.shared
    
    @Binding var word: Word
    @State private var isShareSheetPresented = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(word.word)
                .font(.title)
                .fontWeight(.bold)
            Text(word.qualifier)
                .font(.caption)
            Rectangle().frame(height: 0.5).background(Color.white)
            Text(word.definition)
                .lineSpacing(5)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top)
                .padding(.bottom)
            HStack {
                Spacer()
            Text(word.example)
                .italic()
                .lineSpacing(5)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            .padding(.bottom)
            HStack {
                Button {
                    word.isFavorite.toggle()
                    favButtonTapped(word: word)
                } label: {
                    Image(systemName: word.isFavorite ? "suit.heart.fill" : "suit.heart")
                }
                .buttonStyle(.plain)
                Spacer()
                Button {
                    isShareSheetPresented = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
                .buttonStyle(.plain)
                .sheet(isPresented: $isShareSheetPresented) {
                    if let url = URL(string: "https://apps.apple.com/us/app/fabula/id6443920494") {
                        ShareSheetView(activityItems: ["Voici un mot que j'ai trouvée sur l'application Fabula:\n\(word.word)", url])
                    }
                }
            }
            .padding(.bottom, 20)
        }
    }
    
    func favButtonTapped(word: Word) {
        if word.isFavorite {
            dataController.addWordFav(word: word)
        } else {
            dataController.fetchWordFav()
            let saveFav = dataController.savedFavWords.first { wordFav in
                wordFav.word == word.word
            }
            if saveFav != nil {
                dataController.deleteFav(favWord: saveFav!)
            }
        }
    }
    
}

struct WordView_Previews: PreviewProvider {
    static var previews: some View {
        WordView(word: .constant(Word(word: "Apoplexie", definition: "Perte de connaissance soudaine, due à l'arrêt des fonctions cérébrales. Egalement appelée attaque cérébrale.", qualifier: "nom", example: "Le bonhome tomba d'abord comme frappé d'apoplexie", isFavorite: false)))
    }
}
