//
//  IAPViewModel.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 08/02/2023.
//

import SwiftUI
import Glassfy

class IAPViewModel: ObservableObject {
    
    @Published var products: [Glassfy.Sku] = []
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var isPremium: Bool = false
    
    init() {
        fetchProducts()
    }
    
    func fetchProducts() {
        Glassfy.offerings { offers, err in
            if let offerings = offers?["Premium"] {
                self.products = offerings.skus
            }
        }
    }
    
    func purchase(product: Glassfy.Sku) {
        isLoading = true
        Glassfy.purchase(sku: product) { transaction, err in
            self.isLoading = false
            if let error = err {
                self.errorMessage = error.localizedDescription
                print("PURCHASE ERROR: \(error.localizedDescription)")
                self.showError.toggle()
                return
            }
            if let permission = transaction?.permissions["Premium"], permission.isValid {
                self.isPremium = true
                print("ACHAT REUSSI")
            }
        }
    }
    
    func restorePurchase() {
        isLoading = true
        Glassfy.restorePurchases { permissions, err in
            self.isLoading = false
            if let error = err {
                self.errorMessage = error.localizedDescription
                self.showError.toggle()
                return
            }
            if let permissions, let permission = permissions["Premium"], permission.isValid {
                print("RESTAURATION REUSSI")
                self.isPremium = true
            } else {
                self.errorMessage = "Pas d'achat enregistré."
                self.showError.toggle()
            }
        }
    }
    
    func checkPurchase() {
        Glassfy.permissions { permissions, err in
            if let permissions, let permission = permissions["Premium"], permission.isValid {
                self.isPremium = true
            } else {
                self.isPremium = false
            }
            
        }
    }
    
    
}
