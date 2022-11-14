////
////  MainView.swift
////  FabulaSwiftUI
////
////  Created by Raphaël Goupille on 23/06/2022.
////
//
import SwiftUI

struct MainView: View {
    
    @AppStorage(Keys.hasSeenAppIntroduction) var isShowingWelcome = false
    @State private var userAccountIsPresented = false
    
    var body: some View {
        
        if !isShowingWelcome {
            WelcomeView(isShowingWelcome: $isShowingWelcome)
            
        } else {
            TabView {
                
                MenuView()
                    .tabItem {
                        Label("Fabula", systemImage: "house") }
                        
                        SubmitProposalView(showUserAccount: $userAccountIsPresented)
                            .tabItem {
                                Label("Soumettre", systemImage: "square.and.pencil")
                            }
                            
                        SettingsView()
                            .tabItem {
                                Label("Réglages", systemImage: "gear")
                            }
                            
                    }
                    .overlay(UserNavBar(userAccountIsPresented: $userAccountIsPresented))
                    .sheet(isPresented: $userAccountIsPresented) {
                        AccountView()
                    }
                    .transition(.slide)
                    .onAppear {
                        let tabBarAppearance = UITabBarAppearance()
                        tabBarAppearance.configureWithDefaultBackground()
                        if #available(iOS 15.0, *) {
                            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
                        } else {
                        }
                    }
                    .navigationViewStyle(.stack)
            }
        }
    }
    
    struct MainView_Previews: PreviewProvider {
        static var previews: some View {
            MainView()
        }
    }
