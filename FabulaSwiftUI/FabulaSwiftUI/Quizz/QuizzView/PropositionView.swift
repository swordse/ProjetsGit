//
//  PropositionView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 04/07/2022.
//

import SwiftUI

struct PropositionView: View {
    
    var geo : GeometryProxy?
    @Binding var proposition: String
    @Binding var correctAnswer: String
    @Binding var selectedProposition: String
    @Binding var buttonIsDisabled: Bool
    
    @State var isSelected = false
    
    var body: some View {
        
        if let geo = geo {
            Button {
                isSelected.toggle()
                selectedProposition = proposition
                buttonIsDisabled = true
            } label: {
                if isSelected {
                    HStack{
                        Text(proposition)
                            .font(.system(size: 18, weight: .semibold, design: .default))
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                            .cornerRadius(10)
                            .padding(.leading, 15)
                        Spacer()
                        Image(systemName: proposition == correctAnswer ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 25)
                            .foregroundColor(proposition == correctAnswer ? .green : .red)
                            .padding(.trailing, 15)
                    }
                    .frame(width: geo.size.width - 20, height: 50)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(.white, lineWidth: 1))
                    .background(Color.lightBackground)
                } else {
                    HStack{
                        Text(proposition)
                            .font(.system(size: 18, weight: .semibold, design: .default))
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                            .cornerRadius(10)
                            .padding(.leading, 15)
                        Spacer()
                        Image(systemName: "circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 25)
                            .foregroundColor(.white)
                            .padding(.trailing, 15)
                    }
                    .frame(width: geo.size.width - 20, height: 50)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(.white, lineWidth: 1))
                    .background(Color.lightBackground)
                }
            }
            .disabled(buttonIsDisabled)
        }
    }
    
}

struct PropositionView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { proxy in
            PropositionView(geo: proxy, proposition: .constant("BOB"), correctAnswer: .constant("BOB"), selectedProposition: .constant(""), buttonIsDisabled: .constant(false))
        }
        
    }
}
