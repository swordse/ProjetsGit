//
//  ContentView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 31/05/2022.
//

import SwiftUI

struct MenuView: View {
    
    private let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    private let sections = Menu.menuCategories
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                GeometryReader {
                    geometry in
                    VStack(spacing: 50) {
                        Text("Qu'allez-vous apprendre aujourd'hui ?")
                            .font(.system(.title2, design: .rounded))
                            .bold()
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(sections) { section in
                                NavigationLink {
                                    switch section.title {
                                    case "Anecdotes":
                                        NavigationLazyView(AllAnecdotesView())
                                    case "Citations":
                                        NavigationLazyView(AllQuotesView())
                                    case "Mot du jour":
                                        NavigationLazyView(AllWordsView())
                                    case "Quizz":
                                        NavigationLazyView(HomeQuizzView())
                                    default:
                                        Text("Anecdote")
                                    }
                                } label: {
                                    MenuRectangleView(geometry: geometry, section: section)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(Text("Fabula"))
        }
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
