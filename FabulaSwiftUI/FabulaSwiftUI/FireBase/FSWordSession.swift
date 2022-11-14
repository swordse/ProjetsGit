//
//  FSWordSession.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 28/06/2022.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
//import PromisesTestHelpers

protocol FSWordSession {
    
    func getWords() async throws -> (words: [Word], snapshots: [QueryDocumentSnapshot?])
    
    func getNewWords(snapshots: [QueryDocumentSnapshot?]) async throws -> (words: [Word], snapshots: [QueryDocumentSnapshot?])
    
    func getPreviousWords(snapshots: [QueryDocumentSnapshot?]) async throws -> (words: [Word], snapshots: [QueryDocumentSnapshot?])
    
    func getAllWords() async throws -> ([String])
    
    func getSpecificWord(word: String) async throws -> Word
}

final class WordSession: FSWordSession {
    
    let dataBase = Firestore.firestore()
    
    private var limitNumber = Constant.numberOfData
    
    func getWords() async throws -> (words: [Word], snapshots: [QueryDocumentSnapshot?]) {
        
        let docRef = dataBase.collection(DataRequest.words.rawValue).order(by: "date", descending: true).limit(to: limitNumber)
        do {
            let callResult = try await docRef.getDocuments()
            
            let words: [Word] = callResult.documents.compactMap { queryDocumentSnapshot in
                let word = try! queryDocumentSnapshot.data(as: Word.self)
                return word
            }
            
            let lastSnapshot = callResult.documents.last
            return (words: words, snapshots: [lastSnapshot])
        }
        catch {
            print(error)
            throw error
        }
    }
    
    func getNewWords(snapshots: [QueryDocumentSnapshot?]) async throws -> (words: [Word], snapshots: [QueryDocumentSnapshot?]) {
        
        guard let lastSnapshot = snapshots.last else {
            return (words: [], snapshots: [nil]) }
        
        guard let lastSnapshot = lastSnapshot else {
            return (words: [], snapshots: [nil]) }
        
        var newSnapshots = snapshots
        let docRef = dataBase.collection(DataRequest.words.rawValue).order(by: "date", descending: true).limit(to: limitNumber).start(atDocument: lastSnapshot)
        
        do {
            let callResult = try await docRef.getDocuments()
            
            let words: [Word] = callResult.documents.compactMap { queryDocumentSnapshot in
                let word = try! queryDocumentSnapshot.data(as: Word.self)
                return word
            }
            
            let newLastSnapshot = callResult.documents.last
            newSnapshots.append(newLastSnapshot)
            return (words: words, snapshots: newSnapshots)
        }
        catch {
            print("error occured")
            throw error
        }
    }
    
    func getPreviousWords(snapshots: [QueryDocumentSnapshot?]) async throws -> (words: [Word], snapshots: [QueryDocumentSnapshot?]) {
        
        var docRef: Query
        
        var currentSnapshots = snapshots
        // if number of snapshot < 3, go back implies to restart from start
        if currentSnapshots.count < 3 {
            currentSnapshots.removeAll()
            docRef = dataBase.collection(DataRequest.words.rawValue).order(by: "date", descending: true).limit(to: limitNumber)
            
            // else we have to remove the 2 last (the last obtained at the end of each request)
        } else {
            currentSnapshots.removeLast()
            currentSnapshots.removeLast()
            
            if let snapshot = currentSnapshots.last  {
                docRef = dataBase.collection(DataRequest.words.rawValue).order(by: "date", descending: true).limit(to: limitNumber).start(atDocument: snapshot!)
            }
            else {
                docRef = dataBase.collection(DataRequest.words.rawValue).order(by: "date", descending: true).limit(to: limitNumber)
            }
        }
        
        do {
            let callResult = try await docRef.getDocuments()
            
            let words : [Word] = callResult.documents.compactMap { queryDocumentSnapshot in
                let word = try! queryDocumentSnapshot.data(as: Word.self)
                return word
            }
            
            let lastSnapshot = callResult.documents.last
            currentSnapshots.append(lastSnapshot)
            
            return (words: words, snapshots: currentSnapshots)
        }
        catch {
            throw error
        }
    }
    
    func getAllWords() async throws -> ([String]) {
        
        let docRef = dataBase.collection(DataRequest.allWords.rawValue)
        
        let callResult = try await docRef.getDocuments()
        let allWords = callResult.documents.compactMap { query in
            (query.data()["words"] as! [String])
        }
        guard allWords.count > 0 else { return [] }
        return allWords[0]
    }
    
    func getSpecificWord(word: String) async throws -> Word {
        let docRef = dataBase.collection(DataRequest.words.rawValue).whereField("word", isEqualTo: word)
        
        let callResult = try await docRef.getDocuments()
        
        let words : [Word] = callResult.documents.compactMap { queryDocumentSnapshot in
            let word = try! queryDocumentSnapshot.data(as: Word.self)
            return word
        }
        
        if words.isEmpty {
            throw NetworkError.errorOccured
        } else {
            return words.first!
        }
    }
    
}
