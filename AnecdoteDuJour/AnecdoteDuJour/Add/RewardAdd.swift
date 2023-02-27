//
//  RewardAdd.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 02/02/2023.
//

import Foundation
import UIKit
import GoogleMobileAds

/// Class responsible for loading and presenting ads
///

class AdCoordinator: NSObject {
    
    private var ad: GADRewardedAd?
    
    func loadAd() {
        GADRewardedAd.load(withAdUnitID: "ca-app-pub-3940256099942544/1712485313", request: GADRequest()) { ad, error in
            if let error = error {
                return print("Failed to load ad with error: \(error.localizedDescription)")
            }
            self.ad = ad
        }
    }
    
    func presentAd(from viewController: UIViewController, rewardFunction: @escaping () -> Void) -> String? {
        
        guard let fullScreenAd = ad else {
            return "Veuillez réessayer dans quelques instants."
        }
//        if let fullScreenad == nil {
//            return rewardFunction(.failure(.noAddLoaded))
//        }
        
        fullScreenAd.present(fromRootViewController: viewController, userDidEarnRewardHandler: rewardFunction)
        return nil
    }
    
}


//final class RewardAd: NSObject, GADFullScreenContentDelegate {
//
//    private var rewardAd: GADRewardedAd?
//
//    override init() {
//        super.init()
//        loadRewardedAd()
//    }
//
//    func loadRewardedAd() {
//        let request = GADRequest()
//        GADRewardedAd.load(withAdUnitID: "ca-app-pub-3940256099942544/1712485313", request: request) { [self] ad, error in
//            if let error = error {
//                print("Failed to load add, error: \(error.localizedDescription)")
//                return
//            }
//            print("REWARDAD LOADED")
//            rewardAd = ad
//            rewardAd?.fullScreenContentDelegate = self
//        }
//    }
//    /// Tells the delegate that the ad failed to present full screen content.
//    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
//        print("Ad did fail to present full screen content: \(error.localizedDescription)")
//    }
//    /// Tells the delegate that the ad dismissed full screen content.
//    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//        loadRewardedAd()
//    }
//
//    func showRewardedAd(rewardFunction: @escaping () -> Void) {
//        if rewardAd != nil {
//            let root = UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first { $0.isKeyWindow}?.rootViewController
////            let root =  UIApplication.shared.connectedScenes
////                .filter { $0.activationState == .foregroundActive }
////                .first(where: { $0 is UIWindowScene })
////                .flatMap({ $0 as? UIWindowScene })?.windows
////                .first(where: \.isKeyWindow)?.rootViewController
////            let root = UIApplication.shared.windows.first?.rootViewController
//            rewardAd?.present(fromRootViewController: root!, userDidEarnRewardHandler: rewardFunction)
//        }
//    }
//
//
//
//}
