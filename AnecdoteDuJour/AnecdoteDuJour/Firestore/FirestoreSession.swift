//
//  FirestoreSession.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 21/01/2023.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

final class AnecdoteSession {
    
    private var limitNumber = 8
    private var maxIndex = 0
    private let dataBase = Firestore.firestore()
    
    // MARK: Anecdotes
    func getAnecdotes(filterBy: Anecdote.Category?) async throws -> (anecdotes:  [Anecdote], snapshot: QueryDocumentSnapshot?) {
        var docRef: Query
        print("GETANECDOTES IS CALLED")
        if filterBy == nil {
            docRef = dataBase.collection("anecdotes").order(by: "date", descending: true).limit(to: limitNumber)
            maxIndex = 0
        } else {
            docRef = dataBase.collection("anecdotes").whereField("category", isEqualTo: filterBy!.rawValue).order(by: "date", descending: true).limit(to: limitNumber)
            // si une catégorie est demandée dans getAnecdotes, on redémarre à 0
            maxIndex = 0
        }
        do {
            let callResult = try await docRef.getDocuments()
            
            let anecdotes: [Anecdote] = callResult.documents.compactMap { queryDocumentSnapshot in
                maxIndex += 1
                let data = queryDocumentSnapshot.data()
                let category = Anecdote.Category(rawValue: data["category"] as! String)
                let title = data["title"] as! String
                let text = data["text"] as! String
                let source = data["source"] as? String
                let index = maxIndex
                //                var anecdote = try! queryDocumentSnapshot.data(as: Anecdote.self)
                let anecdoteId = queryDocumentSnapshot.documentID
                //                anecdote.id = anecdoteId
                let anecdote = Anecdote(id: anecdoteId, category: category ?? .inclassable, title: title, text: text, source: source, index: index)
                return anecdote
            }
            
            let lastSnapshot = callResult.documents.last
            return (anecdotes: anecdotes, snapshot: lastSnapshot)
        }
        catch {
            throw error
        }
    }
    
    
    func getNewAnecdotes(filterBy: Anecdote.Category?, snapshot: QueryDocumentSnapshot?) async throws -> (anecdotes: [Anecdote], snapshot: QueryDocumentSnapshot?) {

        print("GET NEWANECDOTE IS CALLED")
//        guard let lastSnapshot = snapshots.last else {
//            return (anecdotes: [], snapshots: [nil]) }

        guard let lastSnapshot = snapshot else {
            print("PAS DE LASTSNPSHOT dans getnewanecdote")
            return (anecdotes: [], snapshot: nil) }

//        var newSnapshots = snapshots
        var docRef : Query
        if filterBy != nil {
            
            docRef = dataBase.collection("anecdotes").whereField("category", isEqualTo: filterBy!.rawValue).order(by: "date", descending: true).limit(to: limitNumber).start(afterDocument: lastSnapshot)
        } else {
            docRef = dataBase.collection("anecdotes").order(by: "date", descending: true).limit(to: limitNumber).start(afterDocument: lastSnapshot)
        }
        do {
            let callResult = try await docRef.getDocuments()

            let anecdotes: [Anecdote] = callResult.documents.compactMap { queryDocumentSnapshot in
                maxIndex += 1
                let data = queryDocumentSnapshot.data()
                let category = Anecdote.Category(rawValue: data["category"] as! String)
                let title = data["title"] as! String
                let text = data["text"] as! String
                let source = data["source"] as? String
                let anecdoteId = queryDocumentSnapshot.documentID
                let anecdote = Anecdote(id: anecdoteId, category: category ?? .inclassable, title: title, text: text, source: source, index: maxIndex)
                return anecdote
            }
//            print("anecdotes dans getNewAnecdotes: \(anecdotes)")
            let newLastSnapshot = callResult.documents.last
            return (anecdotes: anecdotes, snapshot: newLastSnapshot)
        }
        catch {
            print("error occured")
            throw error
        }
    }
    
}
