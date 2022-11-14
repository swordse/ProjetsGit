//
//  BannerAddView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 27/07/2022.
//

import SwiftUI
import GoogleMobileAds

struct BannerAddView: View {
    
    @State var height: CGFloat = 0 //Height of ad
    @State var width: CGFloat = 0 //Width of ad
    let adUnitId: String
    
    init(adUnitId: String) {
        self.adUnitId = adUnitId
    }
    
    var body: some View {
        Banner(adUnitId: adUnitId)
            .frame(width: width, height: height, alignment: .center)
            .onAppear {
                setFrame()
            }
    }
    
    func setFrame() {
        let safeAreInsets = UIApplication.shared.windows.first { $0.isKeyWindow }? .safeAreaInsets ?? .zero
        let frame = UIScreen.main.bounds.inset(by: safeAreInsets)
        let adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(frame.width)
        self.width = adSize.size.width
        self.height = adSize.size.height
    }
}

struct BannerAddView_Previews: PreviewProvider {
    static var previews: some View {
        BannerAddView(adUnitId: "ca-app-pub-3940256099942544/2934735716")
    }
}
