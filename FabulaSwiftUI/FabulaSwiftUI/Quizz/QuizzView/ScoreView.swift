//
//  ScoreView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 05/07/2022.
//

import SwiftUI

struct ScoreView: View {
    
    @Binding var score: Int
    
    var body: some View {
        
        VStack(spacing: 20) {
            if score > 5 {
                LottieView(name: "trophy", numberOfRepeat: 2, height: 200)
                    .frame(height: 200)
            } else {
                LottieView(name: "missed", numberOfRepeat: 2, height: 300)
                    .frame(height: 200)
            }
            Text("\(score) réponses correctes")
                           .font(.title3)
                           .fontWeight(.bold)
                           .multilineTextAlignment(.center)
            Text("\(10 - score) réponses incorrectes")
                           .font(.title3)
                           .fontWeight(.bold)
                           .multilineTextAlignment(.center)
        }
    }
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView(score: .constant(4))
    }
}
