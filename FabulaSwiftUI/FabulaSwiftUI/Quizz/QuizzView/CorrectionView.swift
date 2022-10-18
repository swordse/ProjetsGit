//
//  CorrectionView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 29/09/2022.
//

import SwiftUI

struct CorrectionView: View {
    
    let quizzs: [Quizz]
    let playerResponses: [String]
    
    var body: some View {
        ZStack{
            Color.background
                .ignoresSafeArea()
            ScrollView {
                
                Text("Correction")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                
                ForEach(0..<quizzs.count, id: \.self) { index in
                    
                    Text(quizzs[index].question)
                        .font(.title3)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    HStack(alignment: .center){
                        Text("Bonne réponse:")
                            .fontWeight(.medium)
                        Text(quizzs[index].answer)
                        Spacer()
                    }
                    .padding()
                    
                    HStack(alignment: .center){
                        Text("Votre réponse:")
                            .fontWeight(.medium)
                        Text(playerResponses[index])
                            .foregroundColor(playerResponses[index] == quizzs[index].answer ? .green : .red)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    Rectangle().frame(height: 0.5).foregroundColor(.white)
                        .padding()
                }
            }
            
            
        }
    }
}

struct CorrectionView_Previews: PreviewProvider {
    static var previews: some View {
        CorrectionView(quizzs: [Quizz(question: "Quel est votre âge?", answer: "20 ans", propositions: ["20 ans", "30"]), Quizz(question: "Quelle est la capitale de la France?", answer: "Paris", propositions: ["", ""])], playerResponses: ["20 ans", "Londres"])
    }
}
