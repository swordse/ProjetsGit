//
//  FooterView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 16/06/2022.
//

import SwiftUI

struct FooterView: View {
    
    @Binding var nextIsTapped: Bool
    @Binding var previousIsTapped: Bool
    @Binding var showInterstitialAd: Bool
    
    var pageNumber: Int
    var isPreviousHidden: Bool
    var isNextHidden: Bool
    
    var body: some View {
        VStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.background, Color.background, Color.background.opacity(0.8), Color.background.opacity(0.1)]), startPoint: .bottom, endPoint: .top)
                Spacer()
                Text("\(pageNumber)")
                    .font(.body)
                    .fontWeight(.medium)
                Spacer()
                HStack(alignment: .top) {
                    if !isPreviousHidden{
                        Button {
                            previousIsTapped.toggle()
                        } label: {
                            Image(systemName: "arrow.backward.circle")
                                .font(.title)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    Spacer()
                    if !isNextHidden {
                        Button {
                            nextIsTapped.toggle()
                            showInterstitialAd.toggle()
                        } label: {
                            Image(systemName: "arrow.forward.circle")
                                .font(.title)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .frame(height: 45)
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
}


