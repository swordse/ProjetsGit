//
//  Menu.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 31/05/2022.
//

import SwiftUI


struct Menu: Identifiable {
    
    var id = UUID()
    var title: String
    var icon: Image
    var color: Color
    
    static var menuCategories = [Menu(title: "Anecdotes",
                                      icon: Image("book"),
                                      color: Color.pink),
                                 Menu(title: "Citations",
                                      icon: Image("quote"),
                                      color: Color.purple),
                                 Menu(title: "Mot du jour",
                                      icon: Image("bubble"),
                                      color: Color(.systemBlue)),
                                 Menu(title: "Quizz",
                                      icon: Image("game"),
                                      color: Color("orange"))]
}
