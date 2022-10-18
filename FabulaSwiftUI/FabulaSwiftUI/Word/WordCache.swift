//
//  WordCache.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 02/10/2022.
//

import Foundation

class WordCache {
    
    static let shared = WordCache()
    let key: NSString = "Word"
    
    let cache = NSCache<NSString, WordState>()
    
    private init() { }
    
    func getWordState() -> WordState? {
        return cache.object(forKey: key)
    }
    
    func saveWordState(wordState: WordState) {
        cache.setObject(wordState, forKey: key)
    }
    
}
