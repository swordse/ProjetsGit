//
//  PurchaseManager.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 05/02/2023.
//

import Foundation
import Glassfy

class PurchaseManager {
    
    static let shared = PurchaseManager()
    
    private init() { }
    
    func configure() {
        Glassfy.initialize(apiKey: "538e4b26bd8d404a8f0c5b7ee520b949")
    }
    
    func fetchProducts() -> [Glassfy.Sku] {
        var returnOfferings: [Glassfy.Sku] = []
        Glassfy.offerings { offers, err in
            
            if let offerings = offers?["Premium"] {
                returnOfferings = offerings.skus
            }
        }
        return returnOfferings
    }
    
//    func fetchProducts() async -> [Glassfy.Sku]? {
////        var skus: [Glassfy.Sku] = []
//        do {
//            return try await Glassfy.offerings().all[0].skus
//        } catch {
//            print(error.localizedDescription)
//            return nil
//        }
////        Glassfy.offerings { offers, error in
////            if let offering = offers?["Premium"] {
////                skus = offering.skus
////                print("SKUS  // \(skus)")
////            }
////        }
////        return skus
//    }
    
    
    func getProducts() async -> Glassfy.Sku? {
        do {
            
            return try await Glassfy.sku(id: Access.fullAccessYearly.rawValue)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func hasPurchased() async -> Bool {
        do {
            let permissions = try await Glassfy.permissions()
            for p in permissions.all {
                switch p.permissionId {
                case "Premium":
                    if p.isValid {
                        return true
                    } else {
                        return false
                    }
                default : print("PAS DE PERMISSION")
                    return false
                }
            }
            return false
        } catch {
            print(error.localizedDescription)
            return false
        }
//        do {
//            let permissions = try await Glassfy.permissions()
//            if permissions[Access.fullAccessYearly.rawValue]?.isValid == true || permissions[Access.fullAccessMonthly.rawValue]?.isValid == true {
//                return true
//            } else {
//                return false
//            }
//        } catch {
//            print(error.localizedDescription)
//            return false
//        }
    }
    
    func purchase(product: Glassfy.Sku) async throws -> Bool{
        do {
            let transaction = try await Glassfy.purchase(sku: product)
            if let premium = transaction.permissions["Premium"], premium.isValid {
                return true
            } else { return false }
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func restorePurchase() async throws -> Bool {
        do {
            let permissions = try await Glassfy.restorePurchases()
            if let permission = permissions["Premium"], permission.isValid {
                print("Restored Successfully")
                return true
            } else { return false }
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}
