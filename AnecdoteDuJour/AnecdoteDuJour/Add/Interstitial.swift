//
//  Interstitial.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 01/02/2023.
//

import Foundation
import UIKit
import GoogleMobileAds


final class Interstitial: NSObject, GADFullScreenContentDelegate {
    
    private var interstitial: GADInterstitialAd?
    private let adUnitID = "ca-app-pub-3940256099942544/4411468910"
//    private let adUnitID = "ca-app-pub-8419450680227145/8592876432"
    override init() {
        super.init()
        loadInterstitial()
    }
    
    func loadInterstitial(){
        let request = GADRequest()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            request.scene = UIApplication.shared.windows.first?.rootViewController?.view.window?.windowScene
        }
        
        GADInterstitialAd.load(withAdUnitID:adUnitID,
                                    request: request,
                          completionHandler: { [self] ad, error in
                            if let error = error {
                              print("Failed to load interstitial ad: \(error.localizedDescription)")
                              return
                            }
                            interstitial = ad
                            interstitial?.fullScreenContentDelegate = self
                          }
        )
    }
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        loadInterstitial()
    }
    
    func showAd(){
        let root = UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first { $0.isKeyWindow}?.rootViewController
//        let root = UIApplication.shared.windows.first?.rootViewController
        interstitial?.present(fromRootViewController: root!)
    }
}
