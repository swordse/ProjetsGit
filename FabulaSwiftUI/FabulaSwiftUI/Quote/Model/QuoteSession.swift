//
//  QuoteSession.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 12/06/2022.
//

import Foundation
import Firebase


final class QuoteService {
    
    let session: FSQuoteSession
    
    init(session: FSQuoteSession = QuoteSession()) {
        self.session = session
    }
    
    func getQuotes(filterBy: QuoteCategoriesMenu?) async throws -> (quotes: [Quote], snapshots: [QueryDocumentSnapshot?]) {
        return try await session.getQuotes(filterBy: filterBy)
    }
    
    func getNewQuotes(filterBy: QuoteCategoriesMenu?, snapshots: [QueryDocumentSnapshot?]) async throws -> (quotes: [Quote], snapshots: [QueryDocumentSnapshot?]) {
        return try await session.getNewQuotes(filterBy: filterBy, snapshots: snapshots)
    }
    
    func getPreviousQuotes(filterBy: QuoteCategoriesMenu?, snapshots: [QueryDocumentSnapshot?]) async throws -> (quotes: [Quote], snapshots: [QueryDocumentSnapshot?]) {
        return try await session.getPreviousQuotes(filterBy: filterBy, snapshots: snapshots)
    }
    
}
