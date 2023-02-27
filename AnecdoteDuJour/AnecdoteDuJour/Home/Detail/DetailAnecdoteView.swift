//
//  DetailAnecdoteView.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 24/01/2023.
//

import SwiftUI

struct DetailAnecdoteView: View {
    
    let anecdote: Anecdote
    
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: []) var favAnecdotes: FetchedResults<FavAnecdote>
    
    @State private var isShareSheetPresented = false
    @State private var isFav = false
    @State private var animatedContent = false
    

    var body: some View {
        VStack(spacing: 10) {
            
            VStack(spacing: 10) {
                Text(anecdote.category.rawValue.uppercased())
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(Color(anecdote.category.rawValue))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.horizontal, .top])
                Text(anecdote.title)
                    .font(Font.system(.title2, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)
                    .padding(.bottom)
            }
            Divider()
            HStack {
                Button {
                    isShareSheetPresented.toggle()
                } label: {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Partager".uppercased())
                            .font(.caption2)
                    }.padding(.vertical, 8)
                        .padding(.horizontal, 20)
                        .background{
                            RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.ultraThinMaterial)
                        }
                }
                .sheet(isPresented: $isShareSheetPresented) {
                    if let url = URL(string: "https://apps.apple.com/us/app/fabula/id6443920494") {
                        ShareSheetView(activityItems: ["Voici une anecdote que j'ai trouvée sur l'application Anecdote du Jour: \n\(anecdote.text)", url])
                    }
                }
                Button {
                    favIsTapped()
                } label: {
                    HStack {
                        Image(systemName: isFav ? "heart.fill" : "heart")
                        Text("Favoris".uppercased()).font(.caption2)
                    }
                }.padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background{
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.ultraThinMaterial)
                    }
                    .onAppear(perform: {
                        print("onAppear call ")
                        print("AnecdoteID: \(anecdote.id)")
                        for favAnecdote in favAnecdotes {
                            if favAnecdote.id == anecdote.id {
                                isFav = true
                                break
                            }
                        }
                    })
                    .onDisappear {
                        print("ON DISAPPEAR IS CALLED")
                        isFav = false
                    }
            }.padding(10)
            Text(anecdote.text.replacingOccurrences(of: "\\n", with: "\n"))
                .font(Font.system(.body, design: .rounded).leading(.loose))
                .padding(.horizontal)
                .padding(.bottom)
            
            Divider()
            HStack {
                if let source = anecdote.source{
                    Text("Source : ")
                    Button {
                        source.openUrl()
                    } label: {
                        Text(source.getShortUrl())
                    }
                    Spacer()
                }
            }
            .padding()
//            .padding(.bottom, 30)
//            .opacity(animatedContent ? 1 : 0)
            Divider()
            AddView()
                .padding(.bottom, 50)
//            BannerAd(unitID: "ca-app-pub-3940256099942544/2934735716")
//                .frame(height: 100)
//                .padding(.bottom, 100)
        }
        .onAppear {
            print("ON APPEAR DETAIL ANECDOTE ")
        }
//        .ignoresSafeArea()

    }
    
    func favIsTapped() {
        if isFav {
            let saveFav = favAnecdotes.first { favAnecdote in
                favAnecdote.id == anecdote.id
            }
            if saveFav != nil {
                viewContext.delete(saveFav!)
                try? viewContext.save()
                isFav.toggle()
            }
        } else {
            let favAnecdote = FavAnecdote(context: viewContext)
            favAnecdote.title = anecdote.title
            favAnecdote.category = anecdote.category.rawValue
            favAnecdote.text = anecdote.text
            favAnecdote.id = anecdote.id
            try? viewContext.save()
            isFav.toggle()
        }
    }

}

struct DetailAnecdoteView_Previews: PreviewProvider {
    static var previews: some View {
        DetailAnecdoteView(anecdote: Anecdote.fakeDatas[0])
    }
}
