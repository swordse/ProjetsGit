//
//  SingleWelcomeView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 08/07/2022.
//

import SwiftUI

struct SingleWelcomeView: View {
    
    @Binding var isShowingWelcome: Bool
    
    let geometry: GeometryProxy
    let section: WelcomeData
    let index: Int
    
    var body: some View {
        VStack {
            
            if index == 0 || index == 5 {
                Image(section.imageName)
                    .resizable()
                    .foregroundColor(.white)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width/2)
            } else {
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .fill(section.color ?? .blue)
                        .cornerRadius(30)
                        .frame(width: geometry.size.width/2.2, height: geometry.size.width/2.5 )
                        .shadow(color: Color.black.opacity(0.7), radius: 2, x: 3, y: 3)
                    
                    VStack(spacing: 20) {
                        Image(section.imageName)
                            .resizable()
                            .foregroundColor(.white)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width/6)
                        
                        Text(section.categoryTitle)
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.bottom, geometry.size.height/20)
                    }
                }
            }
            Text(section.categoryTitle)
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(.top, 50)
            Text(section.categoryDescription)
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(10)
            if index == WelcomeData.welcomeViewData.count - 1 {
                Button {
                    UserDefaultsManager.manager.hasSeenAppIntroduction = true
                    isShowingWelcome.toggle()
                } label: {
                    ButtonView(text: "COMMENCER")
                }
                .padding()
            }
        }
    }
}

struct SingleWelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        
        GeometryReader { proxy in
            SingleWelcomeView(isShowingWelcome: .constant(false), geometry: proxy, section: WelcomeData.welcomeViewData[0], index: 0)
        }
        
    }
}
