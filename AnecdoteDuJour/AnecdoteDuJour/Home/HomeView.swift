//
//  HomeView.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 17/01/2023.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var networkChecker: NetworkChecker
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject var viewModel = ViewModel()
    @StateObject var iapModel: IAPViewModel = .init()
    //    @State private var anecdote = Anecdote.fakeDatas[0]
    @State private var showDetail = false
    @State private var animatedContent = false
    @State private var currentIndex = 0
    @State private var showMenu = false
    @State private var currentCategory: Anecdote.Category? = .nouveautes
    @State private var selectedAnecdote = Anecdote.fakeDatas[0]
    @State private var showCategories: Bool = false
    @State private var interstitial = Interstitial()
    @State private var showConnectionAlert = false
    @State private var hasAppeared = false
    
    var body: some View {
        
        GeometryReader { proxy in
            ZStack {
                Color("background").ignoresSafeArea()
                if viewModel.anecdotes.isEmpty {
                    VStack(spacing: 30) {
                        ProgressView()
                        Text("Chargement des anecdotes")
                    }
                }
                
                TabView(selection: $currentIndex) {
                    ForEach(viewModel.anecdotes) { anecdote in
                        //                        ZStack {
                        //                            Color("background")
                        //                            if anecdote.title == "BannerAd" {
                        //                                AddView(proxy: proxy)
                        ////                                BannerAd(unitID: "ca-app-pub-3940256099942544/2934735716")
                        ////                                    .frame(height: proxy.size.height/4)
                        //                            } else {
                        BasicView(anecdote: anecdote, showDetail: $showDetail, animatedContent: $animatedContent, selectedAnecdote: $selectedAnecdote)
                        //                            }
                        
                        //                        }
                            .tag(anecdote.index)
                            .ignoresSafeArea()
                    }
                }
                .onChange(of: currentIndex) { index in
                    print("index dans onChange de currentIndex: \(index)")
                    print("ANecdote dans onchange count: \(viewModel.anecdotes.count)")
                    // A FAIRE GERER PAR LE VIEWMODEL
                    if currentIndex%7 == 0 {
                        interstitial.showAd()
                    }
                    Task {
                        await viewModel.currentIndex(index: index, currentCategory: currentCategory)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .ignoresSafeArea()
            .overlay(content: {
                if showDetail {
                    DetailView(showDetail: $showDetail, anecdote: selectedAnecdote)
                }
            })
            .overlay(alignment: .topLeading, content: {
                if currentIndex > 1 && !showDetail {
                    Button {
                        currentIndex = 0
                    } label: {
                        Text("< début")
                            .font(.caption2)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
            })
            .ignoresSafeArea(edges: .bottom)
            .overlay(alignment: .bottomLeading, content: {
                Button {
                    if showDetail {
                        showDetail.toggle()
                        showMenu.toggle()
                    } else {
                        showMenu.toggle()
                    }
                } label: {
                    Image(systemName: "text.justify")
                        .foregroundColor(.primary)
                        .font(.title2)
                        .padding(10)
                        .background(Circle().fill(Color("cellBackground")))
                        .overlay(
                            Circle()
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: Color("shadow").opacity(0.3), radius: 3, x: 0, y: 0)
                }
                .padding()
                .sheet(isPresented: $showMenu) {
                    SettingsSheetMenu()
                        .environmentObject(iapModel)
                }
            })
            .overlay(alignment: .bottomTrailing) {
                Button {
                    if showDetail {
                        showDetail.toggle()
                        showCategories.toggle()
                    } else {
                        showCategories.toggle()
                    }
                } label: {
                    Image(systemName: "square.grid.2x2")
                        .foregroundColor(.primary)
                        .font(.title2)
                        .padding(10)
                        .background(Circle().fill(Color("cellBackground")))
                        .overlay {
                            Circle()
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        }
                        .shadow(color: Color("shadow").opacity(0.3), radius: 3, x: 0, y: 0)
                }.padding()
                    .sheet(isPresented: $showCategories) {
                        CategorySheet(currentCategory: $currentCategory)
                            .environmentObject(iapModel)
                    }
            }
            .onChange(of: currentCategory) { _ in
                currentIndex = 0
                Task {
                    await viewModel.changeCategory(newCategory: currentCategory!)        }
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .background && currentCategory == .nouveautes {
                    Task {
                        await viewModel.getFirstAnecdotes(filterBy: nil)
                    }
                }
            }
//            .onAppear {
//                //            if !hasAppeared {
//                print("ONAPPEAR GET FIRSTANECDOTE")
//                Task {
//                    await viewModel.getFirstAnecdotes(filterBy: nil)
//                }
//                hasAppeared = true
//                //            }
//            }
                    .onFirstAppear {
                        print("ONAPPEAR IS CALLED")
                        Task {
                            await viewModel.getFirstAnecdotes(filterBy: nil)
                        }
                    }
            .onAppear{
                if !networkChecker.isConnected {
                    showConnectionAlert.toggle()
                }
            }
            .onChange(of: networkChecker.isConnected, perform: { newConnection in
                if !networkChecker.isConnected {
                    showConnectionAlert.toggle()
                }
            })
            .alert(isPresented: $showConnectionAlert) {
                Alert(title: Text("Erreur connexion internet"), message: Text("Vous ne semblez pas être connecté. Vérifiez votre connexion"), dismissButton: .cancel())
            }
            //        .sheet(isPresented: $showMenu) {
            //            SettingsSheetMenu()
            //                .environmentObject(iapModel)
            //        }
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
