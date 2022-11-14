//
//  FireStoreSession.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 01/06/2022.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


protocol FSAnecdoteSession {
    
    func getAnecdotes(filterBy: Anecdote.Category?) async throws -> (anecdotes: [Anecdote], snapshots: [QueryDocumentSnapshot?])
    
    func getNewAnecdotes(filterBy: Anecdote.Category?, snapshots: [QueryDocumentSnapshot?]) async throws -> (anecdotes: [Anecdote], snapshots: [QueryDocumentSnapshot?])
    
    func getPreviousAnecdotes(filterBy: Anecdote.Category?, snapshots: [QueryDocumentSnapshot?]) async throws -> (anecdotes: [Anecdote], snapshots: [QueryDocumentSnapshot?])
    
    func readComments(dataRequest: String, anecdoteId: String) async throws -> [Comment]
    
    func save(commentToSave: [String: Any], completion: @escaping (Result<Bool, NetworkError>) -> Void)
    
    func update(comment: Comment, completion: @escaping (Result<Bool, NetworkError>) -> Void)
}


/// generic session used to retrieve info from FireStore
final class AnecdoteSession: FSAnecdoteSession {
    
    private var limitNumber = Constant.numberOfData
    
    private let dataBase = Firestore.firestore()
    
    // MARK: Anecdotes
    func getAnecdotes(filterBy: Anecdote.Category?) async throws -> (anecdotes:  [Anecdote], snapshots: [QueryDocumentSnapshot?]) {
        var docRef: Query
        
        if filterBy == nil {
            docRef = dataBase.collection(DataRequest.anecdotes.rawValue).order(by: "date", descending: true).limit(to: limitNumber)
        } else {
            docRef = dataBase.collection(DataRequest.anecdotes.rawValue).whereField("category", isEqualTo: filterBy!.rawValue).order(by: "date", descending: true).limit(to: limitNumber)
        }
        do {
            let callResult = try await docRef.getDocuments()
            
            let anecdotes: [Anecdote] = callResult.documents.compactMap { queryDocumentSnapshot in
                var anecdote = try! queryDocumentSnapshot.data(as: Anecdote.self)
                let anecdoteId = queryDocumentSnapshot.documentID
                anecdote.id = anecdoteId
                return anecdote
            }
            
            let lastSnapshot = callResult.documents.last
            return (anecdotes: anecdotes, snapshots: [lastSnapshot])
        }
        catch {
            print(error)
            throw error
        }
    }
    
    func getNewAnecdotes(filterBy: Anecdote.Category?, snapshots: [QueryDocumentSnapshot?]) async throws -> (anecdotes: [Anecdote], snapshots: [QueryDocumentSnapshot?]) {
        
        guard let lastSnapshot = snapshots.last else {
            return (anecdotes: [], snapshots: [nil]) }
        
        guard let lastSnapshot = lastSnapshot else {
            return (anecdotes: [], snapshots: [nil]) }
        
        var newSnapshots = snapshots
        var docRef : Query
        if filterBy != nil {
            docRef = dataBase.collection(DataRequest.anecdotes.rawValue).whereField("category", isEqualTo: filterBy!.rawValue).order(by: "date", descending: true).limit(to: limitNumber).start(atDocument: lastSnapshot)
        } else {
            docRef = dataBase.collection(DataRequest.anecdotes.rawValue).order(by: "date", descending: true).limit(to: limitNumber).start(atDocument: lastSnapshot)
        }
        do {
            let callResult = try await docRef.getDocuments()
            
            let anecdotes: [Anecdote] = callResult.documents.compactMap { queryDocumentSnapshot in
                var anecdote = try! queryDocumentSnapshot.data(as: Anecdote.self)
                let anecdoteId = queryDocumentSnapshot.documentID
                anecdote.id = anecdoteId
                return anecdote
            }
            
            let newLastSnapshot = callResult.documents.last
            newSnapshots.append(newLastSnapshot)
            return (anecdotes: anecdotes, snapshots: newSnapshots)
        }
        catch {
            print("error occured")
            throw error
        }
    }
    
    func getPreviousAnecdotes(filterBy: Anecdote.Category?, snapshots: [QueryDocumentSnapshot?]) async throws -> (anecdotes: [Anecdote], snapshots: [QueryDocumentSnapshot?]) {
        
        var docRef: Query
        
        var currentSnapshots = snapshots
        // if number of snapshot < 3, go back implies to restart from start
        if currentSnapshots.count < 3 {
            currentSnapshots.removeAll()
            
            if filterBy == nil {
                docRef = dataBase.collection(DataRequest.anecdotes.rawValue).order(by: "date", descending: true).limit(to: limitNumber)
            } else {
                docRef = dataBase.collection(DataRequest.anecdotes.rawValue).whereField("category", isEqualTo: filterBy!.rawValue).order(by: "date", descending: true).limit(to: limitNumber)
            }
            // else we have to remove the 2 last (the last obtained at the end of each request)
        } else {
            currentSnapshots.removeLast()
            currentSnapshots.removeLast()
            
            if let snapshot = currentSnapshots.last  {
                if filterBy == nil {
                    docRef = dataBase.collection(DataRequest.anecdotes.rawValue).order(by: "date", descending: true).limit(to: limitNumber).start(atDocument: snapshot!)
                } else {
                    docRef = dataBase.collection(DataRequest.anecdotes.rawValue).whereField("category", isEqualTo: filterBy!.rawValue).limit(to: limitNumber).start(atDocument: snapshot!)
                }
            }
            else {
                if filterBy == nil {
                    docRef = dataBase.collection(DataRequest.anecdotes.rawValue).order(by: "date", descending: true).limit(to: limitNumber)
                } else {
                    docRef = dataBase.collection(DataRequest.anecdotes.rawValue).whereField("category", isEqualTo: filterBy!.rawValue).limit(to: limitNumber)
                }
            }
        }
        
        do {
            let callResult = try await docRef.getDocuments()
            
            let anecdotes : [Anecdote] = callResult.documents.compactMap { queryDocumentSnapshot in
                var anecdote = try! queryDocumentSnapshot.data(as: Anecdote.self)
                let anecdoteId = queryDocumentSnapshot.documentID
                anecdote.id = anecdoteId
                return anecdote
            }
            
            let lastSnapshot = callResult.documents.last
            currentSnapshots.append(lastSnapshot)

            return (anecdotes: anecdotes, snapshots: currentSnapshots)
        }
        catch {
            throw error
        }
    }
    
    
    // MARK: Comments
    
    func readComments(dataRequest: String, anecdoteId: String) async throws -> [Comment] {
        
        let docRef = dataBase.collection(dataRequest).whereField("anecdoteId", isEqualTo: anecdoteId).order(by: "date", descending: false)
        
        do {
            let callResult = try await docRef.getDocuments()
            
            let comments = callResult.documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: Comment.self)
            }
            return comments
            
        } catch {
            throw error
        }
    }
    
    func save(commentToSave: [String: Any], completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        
        dataBase.collection(DataRequest.comments.rawValue).document(commentToSave["commentId"] as! String).setData(commentToSave) { err in
            if let err = err {
                print("Error writing document: \(err)")
                completion(.failure(NetworkError.errorOccured))
            } else {
                completion(.success(true))
            }
        }
    }
    
    func update(comment: Comment, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        
        let commentRef = dataBase.collection(DataRequest.comments.rawValue).document(comment.commentId)
        commentRef.updateData(["commentText" : comment.commentText]) { err in
            if let err = err {
                print("Error updating document: \(err)")
                completion(.failure(NetworkError.errorOccured))
            } else {
                completion(.success(true))
            }
        }
    }
    
}
