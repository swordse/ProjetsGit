//
//  FullScreenModifier.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 28/07/2022.
//

import SwiftUI


struct FullScreenModifier<Parent: View>: View {
    @Binding var isPresented: Bool
    @State var adType: AdType
    
    //Select adType
    enum AdType {
        case interstitial
        case rewarded
    }
    
    var rewardFunc: () -> Void
    var adUnitId: String
  
    //The parent is the view that you are presenting over
    //Think of this as your presenting view controller
    var parent: Parent
    
    var body: some View {
        ZStack {
            parent
            
            if isPresented {
                EmptyView()
                    .edgesIgnoringSafeArea(.all)
                    InterstitialAdView(isPresented: $isPresented, adUnitId: adUnitId)
            }
        }
        .onAppear {
                InterstitialAd.shared.loadAd(withAdUnitId: adUnitId)
        }
    }
}


extension View {
    public func presentRewardedAd(isPresented: Binding<Bool>, adUnitId: String, rewardFunc: @escaping (() -> Void)) -> some View {
        FullScreenModifier(isPresented: isPresented, adType: .rewarded, rewardFunc: rewardFunc, adUnitId: adUnitId, parent: self)
    }
    
    public func presentInterstitialAd(isPresented: Binding<Bool>, adUnitId: String) -> some View {
        FullScreenModifier(isPresented: isPresented, adType: .interstitial, rewardFunc: {}, adUnitId: adUnitId, parent: self)
    }
}
