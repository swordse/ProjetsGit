//
//  HomeQuizzView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 30/06/2022.
//

import SwiftUI

struct HomeQuizzView: View {
    
    @StateObject var viewModel = HomeQuizzViewModel()
    @State private var selectedCategory = "Histoire"
    @State private var rotationDegree = 0.0
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            if viewModel.categories.isEmpty {
                CustomProgressView()
            }
            else {
                GeometryReader { geo in
                    VStack {
                        Text("Catégorie")
                            .font(.title)
                            .bold()
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack {
                                ForEach(viewModel.categories, id: \.name) { categorie in
                                    Button {
                                        selectedCategory = categorie.name
                                        withAnimation(Animation.easeInOut) {
                                            rotationDegree += 360
                                        }
                                    } label: {
                                        VStack {
                                            categorie.image.resizable().aspectRatio(contentMode: .fit)
                                                .frame(height: geo.size.width/10)
                                                .rotation3DEffect(.degrees(selectedCategory == categorie.name ? rotationDegree : 0.0), axis: (x: 0, y: 1, z: 0))
                                            Text(categorie.name)
                                                .font(.headline)
                                                .fontWeight(.bold).foregroundColor(.white)
                                        }
                                        .frame(width: geo.size.width/3.5, height: geo.size.height/6)
                                        .background(categorie.color)
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(selectedCategory == categorie.name ? .white : Color.background, lineWidth: 2))
                                        .padding(1)
                                    }
                                }
                            }
                        }.frame(height: geo.size.height/5.5)
                        Text("Les quizzs")
                            .font(.title)
                            .bold()
                        List(viewModel.theme[selectedCategory] ?? [], id: \.self) { quizz in
                            NavigationLink {
                                QuizzView(theme: quizz, category: selectedCategory)
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.lightBackground)
                                        .frame(height: 50)
                                    HStack {
                                        Text(quizz)
                                            .font(.title3)
                                            .padding(.leading)
                                        Spacer()
                                        if let score = checkIfThemeHasScore(theme: quizz) {
                                            VStack {
                                                Text("\(score)/10")
                                                    .font(.caption)
                                                Text("dernier score")
                                                    .font(.footnote)
                                                    .padding(.trailing)
                                            }
                                        }
                                    }
                                }
                            }
                            .listRowBackground(Color.background)
                            .hideRowSeparator()
                        }
                        .hideScrollBackground()
                        .listStyle(.plain)
                    }
                }
            }
        }
        .navigationTitle("Quizz")
        .onAppear {
            viewModel.retrieveCategory()
        }
        .alert(isPresented: $viewModel.errorOccured) {
            Alert(title: Text("Erreur"), message: Text("Une erreur s'est produite. Vérifiez votre connexion ou réessayer."), dismissButton: .default(Text("OK")))
        }
    }
    
    private func checkIfThemeHasScore(theme: String) -> Int? {
        for gameScore in viewModel.gameScores {
            if gameScore.theme == theme {
                return Int(gameScore.score)
            }
        }
        return nil
    }
    
}

struct HomeQuizzView_Previews: PreviewProvider {
    static var previews: some View {
        HomeQuizzView()
    }
}
