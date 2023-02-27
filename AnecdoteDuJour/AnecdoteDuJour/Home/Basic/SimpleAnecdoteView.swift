//
//  SimpleAnecdoteView.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 24/01/2023.
//

import SwiftUI

struct SimpleAnecdoteView: View {
    
    var anecdote: Anecdote
    
    var body: some View {
        VStack(spacing: 4) {
            Text(anecdote.category.rawValue.uppercased())
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(Color(anecdote.category.rawValue))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.horizontal, .top])
            Text(anecdote.title)
                .font(Font.system(.title2, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .padding([.horizontal, .bottom])
            
            Text(anecdote.text.replacingOccurrences(of: "\\n", with: "\n"))
                .font(Font.system(.body, design: .rounded).leading(.loose))
                .lineLimit(5)
                .padding(.bottom, 5)
                .padding(.horizontal)
                .padding(.bottom, 30)
        }
    }
}

struct SimpleAnecdoteView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleAnecdoteView(anecdote: Anecdote.fakeDatas[0])
    }
}
