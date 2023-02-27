//
//  CategorySheet.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 27/01/2023.
//

import SwiftUI

struct CategorySheet: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var iapModel: IAPViewModel
    
//    @StateObject var iapModel: IAPViewModel = .init()
    
    @Binding var currentCategory : Anecdote.Category?
    
    @State private var hasSeenRewardAd = false
    @State private var showSubscription = false
    
    var columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var categories = CategoryModel.categories
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color("background").ignoresSafeArea()
            NavigationView {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(categories, id: \.name) { category in
                            VStack {
                                Text(category.name)
                                    .font(.callout)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .padding([.top, .horizontal])
                                Image(category.image)
                                    .padding(.bottom, 20)
                            }
                            .frame(width: proxy.size.width/2.5, height: proxy.size.height/6)
                            .background( LinearGradient(colors: [Color(category.color[0]), Color(category.color[1])], startPoint: .top, endPoint: .bottom))
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                            .overlay(alignment: .bottomLeading, content: {
                                if !iapModel.isPremium && !hasSeenRewardAd && category.name != "Nouveautés" {
                                    Image(systemName: "lock")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                }
                            })
                            .onTapGesture {
                                // Si user a payé un abonnement ou regardé une vidéo
                                if iapModel.isPremium || hasSeenRewardAd {
                                    guard let selectedCategory = Anecdote.Category(rawValue: category.name) else { return }
                                        currentCategory = selectedCategory
                                        presentationMode.wrappedValue.dismiss()
                                } else if category.name == "Nouveautés" {
                                    currentCategory = .nouveautes
                                    presentationMode.wrappedValue.dismiss()
                                } else {
                                    // A défaut on montre la page d'abonnement
                                    showSubscription.toggle()
                                }
                            }
                        }
                    }
                    .navigationTitle("Catégories")
                    .navigationBarTitleDisplayMode(.inline)
                    .background(Color("background"))
                    .toolbar {
                        ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                            Button {
                                presentationMode.wrappedValue.dismiss() } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.gray.opacity(0.3))
                                }
                            
                        }
                    }
                    .sheet(isPresented: $showSubscription) {
                        SubscriptionView(hasSeenRewardAd: $hasSeenRewardAd)
                            .environmentObject(iapModel)
                    }
                }
                .background(Color("background"))
                .hideScrollBackground()
            }
        }
        }
        .onAppear {
            iapModel.checkPurchase()
            print("ONAPPEAR CATEGORY SHEET: \(iapModel.isPremium)") }
    }
}

struct CategorySheet_Previews: PreviewProvider {
    static var previews: some View {
        CategorySheet(currentCategory: .constant(.nouveautes))
    }
}
