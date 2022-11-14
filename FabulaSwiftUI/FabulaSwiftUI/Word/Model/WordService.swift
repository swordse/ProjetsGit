//
//  WordService.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 28/06/2022.
//

import Foundation
import Firebase

final class WordService {
    
    let session: FSWordSession
    
    init(session: FSWordSession = WordSession()) {
        self.session = session
    }
    
    func getWords() async throws -> (words: [Word], snapshots: [QueryDocumentSnapshot?]) {
        try await session.getWords()
    }
    
    func getNewWords(snapshots: [QueryDocumentSnapshot?]) async throws -> (words: [Word], snapshots: [QueryDocumentSnapshot?]) {
        try await session.getNewWords(snapshots: snapshots)
    }
    
    func getPreviousWords(snapshots: [QueryDocumentSnapshot?]) async throws -> (words: [Word], snapshots: [QueryDocumentSnapshot?]) {
        try await session.getPreviousWords(snapshots: snapshots)
    }
    
    func getAllWords() async throws -> ([String]) {
        try await session.getAllWords()
    }
    
    func getSpecificWord(word: String) async throws -> Word {
        try await session.getSpecificWord(word: word)
    }
    
    
}
