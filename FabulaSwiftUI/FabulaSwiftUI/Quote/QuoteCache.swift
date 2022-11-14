//
//  QuoteCache.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 02/10/2022.
//

import Foundation

final class QuoteCache {
    
    static let shared = QuoteCache()
    let cache = NSCache<NSString, QuoteState>()
    
    private init() { }
    
    func getQuoteState(key: String) -> QuoteState? {
        
        let quoteKey = NSString(string: "Quote\(key)")
        
        return cache.object(forKey: quoteKey)
    }
    
    func saveQuoteState(key: String, quoteState: QuoteState) {
        let quoteKey = NSString(string: "Quote\(key)")
        cache.setObject(quoteState, forKey: quoteKey)
    }
}
