//
//  QuizzView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 01/07/2022.
//

import SwiftUI

struct QuizzView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var theme = ""
    var category = ""
    @State private var opacity = 1.0
    @State private var selectedProposition = ""
    @State private var isPlaying = true
    @State private var showCorrection = false
    
    @StateObject var viewModel = QuizzViewModel()
    
    var body: some View {
        ZStack(alignment: .center) {
            Color.background
                .ignoresSafeArea()
            if isPlaying {
                GeometryReader { geo in
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Question: \(viewModel.questionNumber + 1)/10")
                                .font(.system(size: 19, weight: .bold, design: .rounded))
                                .opacity(0.8)
                                .padding(.vertical, 20)
                                .padding(.horizontal, 10)
                            Spacer()
                            Text("Score: \(viewModel.displayedScore)")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .opacity(0.8)
                                .padding(40)
                        }
                        VStack {
                            Text(viewModel.question)
                                .frame(width: geo.size.width/1.3, height: geo.size.height/4)
                                .lineSpacing(10)
                                .font(.system(size: 20, weight: .bold, design: .default))
                                .foregroundColor(Color.white)
                                .multilineTextAlignment(.center)

                                ForEach($viewModel.propositions, id: \.self) { $proposition in
                                    HStack {
                                        Spacer()
                                        PropositionView(geo: geo, proposition: $proposition, correctAnswer: $viewModel.correctAnswer, selectedProposition: $selectedProposition, buttonIsDisabled: $viewModel.buttonIsDisabled)
                                            .padding(.vertical, 10)
                                        Spacer()
                                    }
                                }
                            
                        }
                        .opacity(opacity)
                        .onAnimationCompleted(for: opacity, valueWithoutCompletion: 1.0, completion: {
                            viewModel.nextQuestion()
                            withAnimation(.linear(duration: 0.7)) {
                                opacity = 1.0
                                viewModel.toggleButtonIsDisabled()
                            }
                        })
                    }
                }
            }
            else {
                // show scoreView if game is over
                VStack(spacing: 40) {
                    ScoreView(score: $viewModel.displayedScore)
                    VStack(spacing: 30) {
                        Button {
                            viewModel.restartGame()
                        } label: {
                            ButtonView(text: "RECOMMENCER")
                        }
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            ButtonView(text: "CHANGER DE QUIZZ")
                        }
                        Button {
                            showCorrection.toggle()
                        } label: {
                            ButtonView(text: "CORRECTION")
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.retrieveQuizz(theme: theme)
            viewModel.theme = theme
            viewModel.category = category
        }
        .onChange(of: selectedProposition) { _ in
            viewModel.isCorrect(playerResponse: selectedProposition)
            
            withAnimation(Animation.linear(duration: 0.7).delay(1)) {
                opacity = 0.0
            }
        }
        .onChange(of: viewModel.isOngoing, perform: { newValue in
            withAnimation(.easeIn(duration: 2)) {
                isPlaying = newValue
            }
        })
        .sheet(isPresented: $showCorrection, content: {
            CorrectionView(quizzs: viewModel.quizzs, playerResponses: viewModel.playerResponses)
        })
        .alert(isPresented: $viewModel.errorOccured) {
            Alert(title: Text("Erreur"), message: Text("Une erreur s'est produite. Vérifiez votre connexion ou réessayer."), dismissButton: .default(Text("OK")))
        }
        .navigationTitle(theme)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct QuizzView_Previews: PreviewProvider {
    static var previews: some View {
        QuizzView()
    }
}
