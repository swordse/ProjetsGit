//
//  DetailView.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 22/01/2023.
//

import SwiftUI

struct DetailView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: []) var favAnecdotes: FetchedResults<FavAnecdote>
    
//    @State private var isShareSheetPresented = false
    @State private var animatedContent = true
//    @State private var offSet: CGSize = .zero
    
    @Binding var showDetail: Bool
    
    var anecdote: Anecdote
    @State private var isFav = false
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            DetailAnecdoteView(anecdote: anecdote)
                .onTapGesture {
                    withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                        showDetail.toggle()
                    }
                }
            .overlay(alignment: .topTrailing, content: {
                Button {
                    withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                        showDetail.toggle()
                        animatedContent.toggle()
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.gray.opacity(0.4))
                        .padding()
                }
            })
            .background(Color("cellBackground"))
            .cornerRadius(10)
            .shadow(color: Color("shadow").opacity(0.6), radius: 5, x: 0, y: 7)
        }
        .transition(.scale)
        .opacity(showDetail ? 1 : 0)
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
    
//    func dragAnalyze(height: CGFloat) {
//        switch height {
//
//        case 150...500 :
//            showDetail.toggle()
//        default:
//            offSet = .zero
//        }
//    }
    
}

//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView()
//    }
//}
