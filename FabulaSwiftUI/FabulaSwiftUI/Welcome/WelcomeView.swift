//
//  WelcomView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 08/07/2022.
//

import SwiftUI

struct WelcomeView: View {
    
    @Binding var isShowingWelcome: Bool
    @State private var currentIndex = 0
    private let welcomeData = WelcomeData.welcomeViewData
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            GeometryReader { proxy in
                
                VStack {
                    TabView(selection: $currentIndex, content: {
                        ForEach(0..<welcomeData.count, id: \.self) { index in
                            SingleWelcomeView(isShowingWelcome: $isShowingWelcome, geometry: proxy, section: WelcomeData.welcomeViewData[index], index: index)
                        }
                    })
                    .tabViewStyle(.page(indexDisplayMode: .always))
                }
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(isShowingWelcome: .constant(true))
    }
}
