//
//  BannerAd.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 31/01/2023.
//

import SwiftUI
import GoogleMobileAds

struct BannerAd: UIViewRepresentable {
    
    
    var unitID: String
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    func makeUIView(context: Context) -> GADBannerView {
        
        let adView = GADBannerView(adSize: GADAdSizeLargeBanner)
        adView.backgroundColor = UIColor(named: "deepBlue")
        adView.adUnitID = unitID
        adView.rootViewController = UIApplication.shared.getRootViewController()
        if UIDevice.current.userInterfaceIdiom == .pad {
            let request = GADRequest()
            request.scene = UIApplication.shared.getRootViewController().view.window?.windowScene
            adView.load(request)
        } else {
            adView.load(GADRequest())
        }
        return adView
    }
    
    func updateUIView(_ uiView: GADBannerView, context: Context) {

    }
    
    class Coordinator: NSObject, GADBannerViewDelegate {
        
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
          print("bannerViewDidReceiveAd")
        }

        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
          print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
        }

        func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
          print("bannerViewDidRecordImpression")
        }

        func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
          print("bannerViewWillPresentScreen")
        }

        func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
          print("bannerViewWillDIsmissScreen")
        }

        func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
          print("bannerViewDidDismissScreen")
        }
    }
    
}

// extension to get rootView

extension UIApplication {
    
    func getRootViewController() -> UIViewController {
        
        guard let screen = self.connectedScenes.first as? UIWindowScene else {
            return .init()
            
        }
        
        guard let root = screen.windows.first?.rootViewController else { return .init()
        }
        
        return root
    }
    
}
