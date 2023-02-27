//
//  PurchaseViewModel.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 06/02/2023.
//

import Foundation
import Glassfy


class PurchaseViewModel: ObservableObject {
    
    @Published var products : [Glassfy.Sku] = []
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    @Published var messageError: String = ""
    
    func getProducts() {
        Glassfy.offerings { offerings, error in
            if let offering = offerings?["Premium"] {
                self.products = offering.skus
            }
        }
    }
    
    func purchase(product: Glassfy.Sku) {
        isLoading = true
        Glassfy.purchase(sku: product) { transaction, error in
            self.isLoading = false
            if let error = error {
                self.messageError = error.localizedDescription
                self.showError.toggle()
                return
            }
            if let permission = transaction?.permissions["Premium"], permission.isValid {
                print("Achat effectué")
            }
        }
    }
    
    func restorePurcase() {
        isLoading = true
        Glassfy.restorePurchases { permissions, error in
            self.isLoading = false
            if let error = error {
                self.messageError = error.localizedDescription
                self.showError.toggle()
            }
            if let permission = permissions?["Premium"], permission.isValid {
                print("Restauration réussie")
            }
        }
    }
    
}
