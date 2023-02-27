//
//  AdViewControllerRepresentable.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 03/02/2023.
//

import Foundation
import SwiftUI

struct AdViewControllerRepresentable: UIViewControllerRepresentable {
    
    let viewController = UIViewController()
    
    func makeUIViewController(context: Context) -> UIViewController {
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }

    
}
