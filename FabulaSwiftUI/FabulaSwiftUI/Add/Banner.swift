//
//  Banner.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 27/07/2022.
//

import SwiftUI

final class Banner: UIViewControllerRepresentable {
    
    let adUnitId: String
    
    init(adUnitId: String) {
        self.adUnitId = adUnitId
    }
    
    func makeUIViewController(context: Context) -> BannerAdVC {
        return BannerAdVC(adUnitId: adUnitId)
    }
    
    func updateUIViewController(_ uiViewController: BannerAdVC, context: Context) {
    }
}
