//
//  AnecdoteCache.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 30/09/2022.
//

import Foundation

class AnecdoteCache {
    
    static let shared = AnecdoteCache()
    
    private let cache = NSCache<NSString, AnecdoteState>()
    
    private init() {}
    
    func getAnecdoteState(key: String) -> AnecdoteState? {
        let NSStringKey = NSString(string: key)
        return cache.object(forKey: NSStringKey)
    }
    
    func saveAnecdoteState(key: String, anecdoteState: AnecdoteState) {
        let NSStringKey = NSString(string: key)
        return cache.setObject(anecdoteState, forKey: NSStringKey)
    }
}
