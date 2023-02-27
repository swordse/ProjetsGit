//
//  BasicView.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 22/01/2023.
//

import SwiftUI

struct BasicView: View {
    
    var anecdote: Anecdote
    @Binding var showDetail: Bool
    @Binding var animatedContent: Bool
    @Binding var selectedAnecdote: Anecdote
    
    var body: some View {
        VStack(spacing: 0) {
            SimpleAnecdoteView(anecdote: anecdote)
//            Button {
//                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
//                    selectedAnecdote = anecdote
//                    showDetail.toggle()
//                }
//            } label: {
//                Text("DETAILS")
//                    .font(.headline)
//                    .fontWeight(.bold)
//                    .padding(.vertical, 10)
//                    .padding(.horizontal, 20)
//                    .foregroundColor(.white)
//                    .background(.black)
//                    .cornerRadius(20)
//            }
//            .padding(.bottom)

        }
        .onTapGesture(perform: {
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                selectedAnecdote = anecdote
                showDetail.toggle()
            }
            withAnimation (.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                animatedContent.toggle()
            }
        })
        .background(Color("cellBackground"))
        .cornerRadius(10)
        .shadow(color: Color("shadow").opacity(0.6), radius: 5, x: 0, y: 7)
        .scaleEffect(showDetail ? 1 : 0.94)
        .opacity(showDetail ? 0 : 1)
    }
}



struct BasicView_Previews: PreviewProvider {
    static var previews: some View {
        BasicView(anecdote: Anecdote.fakeDatas[0], showDetail: .constant(false), animatedContent: .constant(false), selectedAnecdote: .constant(Anecdote.fakeDatas[0]))
    }
}
