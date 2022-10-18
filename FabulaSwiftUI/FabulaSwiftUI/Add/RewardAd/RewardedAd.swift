////
////  RewardedAd.swift
////  FabulaSwiftUI
////
////  Created by Raphaël Goupille on 28/07/2022.
////
//
//import Foundation
//import GoogleMobileAds
//
//
//class RewardedAd: NSObject {
//    var rewardedAd: GADRewardedAd?
//    
//    static let shared = RewardedAd()
//    
//    func loadAd(withAdUnitId id: String) {
//        let req = GADRequest()
//        GADRewardedAd.load(withAdUnitID: id, request: req) { [weak self] rewardedAd, err in
//            if let err = err {
//                print("Failed to load ad with error: \(err)")
//                return
//            }
//            
//            self?.rewardedAd = rewardedAd
//        }
//    }
//}
