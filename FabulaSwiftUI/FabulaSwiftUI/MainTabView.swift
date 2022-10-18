//
//  MainTabView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 18/07/2022.
//

import SwiftUI

struct MainTabView: View {
    
    @State private var selectedIndex = 0
    
    @State private var isShowingWelcome = !UserDefaultsManager.manager.hasSeenAppIntroduction
    @State private var userAccountIsPresented = false
    
    var tabIcons = ["house", "square.and.pencil", "gear"]
    var tabNames = ["Accueil", "Soumettre", "Réglages"]
    
    var body: some View {
        
        if isShowingWelcome {
            WelcomeView(isShowingWelcome: $isShowingWelcome)
        } else {
            VStack(spacing: 0){
                ZStack(alignment: .bottom) {
                    switch selectedIndex {
                    case 0:
                        MenuView()
                    case 1:
                        SubmitProposalView(showUserAccount: $userAccountIsPresented)
                    default:
                        SettingsView()
                    }
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.lightBackground)
                        .frame(height: 50)
                        .padding(.horizontal, 10)
                    
                    HStack {
                        ForEach(0..<3) { number in
                            Spacer()
                            Button {
                                self.selectedIndex = number
                            } label: {
                                Image(systemName: tabIcons[number])
                                    .font(.system(size: 25, weight: .regular, design: .default))
                                    .foregroundColor(self.selectedIndex == number ? Color.white : Color.gray)
                            }
                            Spacer()
                        }
                    }
                }
                .padding(.bottom, 30)
            }
            .background(Color.background)
            .ignoresSafeArea()
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .overlay(UserNavBar(userAccountIsPresented: $userAccountIsPresented))
            .sheet(isPresented: $userAccountIsPresented) {
                AccountView()
            }
            .navigationViewStyle(.stack)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
