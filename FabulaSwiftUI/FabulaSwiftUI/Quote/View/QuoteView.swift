//
//  QuoteView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 11/06/2022.
//

import SwiftUI

struct QuoteView: View {
    
    let dataController = DataController.shared
    @Binding var quote: Quote
    @State private var isShareSheetPresented = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 10
        ) {
            Text("\"\(quote.text)\"")
                .padding(.bottom, 10)
                .padding(.top, 40)
                .font(.headline.italic())
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
            VStack(alignment: .leading) {
                Text(quote.author)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            HStack {
                Button {
                    quote.isFavorite.toggle()
                    favButtonTapped(quote: quote)
                } label: {
                    Image(systemName: quote.isFavorite ? "suit.heart.fill" : "suit.heart")
                }
                .buttonStyle(.plain)
                Spacer()
                Button {
                    isShareSheetPresented = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
                .buttonStyle(PlainButtonStyle())
                .sheet(isPresented: $isShareSheetPresented) {
                    ShareSheetView(activityItems: ["Voici une citation que j'ai trouvée sur l'application Fabula:\n\(quote.text)"])
                }
            }
        }.background(Color.background)
    }
    
    func favButtonTapped(quote: Quote) {
        if quote.isFavorite {
            dataController.addQuoteFav(quote: quote)
        } else {
            dataController.fetchQuoteFav()
            let saveFav = dataController.savedFavQuotes.first { quoteFav in
                quoteFav.text == quote.text
            }
            if saveFav != nil {
                dataController.deleteFav(favQuote: saveFav!)
            }
        }
    }
    
}

struct QuoteView_Previews: PreviewProvider {
    static var previews: some View {
        
        QuoteView(quote: .constant(Quote(author: "François Rabelais", text: "Le rire est le propre de l'homme.", category: .amour, isFavorite: false)))
    }
    
}
