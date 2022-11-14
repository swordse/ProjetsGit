//
//  InterstitialAd.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 28/07/2022.
//

import Foundation
import GoogleMobileAds

class InterstitialAd: NSObject {
    var interstitialAd: GADInterstitialAd?
    
    static let shared = InterstitialAd()
    
    func loadAd(withAdUnitId id: String) {
        let req = GADRequest()
        GADInterstitialAd.load(withAdUnitID: id, request: req) { [weak self] interstitialAd, err in
            if let err = err {
                print("Failed to load ad with error: \(err)")
                return
            }
            
            self?.interstitialAd = interstitialAd
        }
    }
}
