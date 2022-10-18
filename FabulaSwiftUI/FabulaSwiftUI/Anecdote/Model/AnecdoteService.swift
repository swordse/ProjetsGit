//
//  AnecdoteService.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 01/06/2022.
//

import Foundation
import Firebase

final class AnecdoteService {
    
    let session: FSAnecdoteSession
    
    init(session: FSAnecdoteSession = AnecdoteSession()){
        self.session = session
    }
    
    func getAnecdotes(filterBy: Anecdote.Category?) async throws -> (anecdotes: [Anecdote], snapshots: [QueryDocumentSnapshot?]) {
        
        return try await session.getAnecdotes(filterBy: filterBy)
    }
    
    func getNewAnecdotes(filterBy: Anecdote.Category?, snapshots: [QueryDocumentSnapshot?]) async throws -> (anecdotes: [Anecdote], snapshots: [QueryDocumentSnapshot?]) {
        
        return try await session.getNewAnecdotes(filterBy: filterBy, snapshots: snapshots)
    }
    
    func getPreviousAnecdotes(filterBy: Anecdote.Category?, snapshots: [QueryDocumentSnapshot?]) async throws -> (anecdotes: [Anecdote], snapshots: [QueryDocumentSnapshot?]) {
        return try await session.getPreviousAnecdotes(filterBy: filterBy, snapshots: snapshots)
    }
    
}
