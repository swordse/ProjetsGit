//
//  FSQuoteSession.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 11/06/2022.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol FSQuoteSession {
    
//    func getThemes() async throws -> [String]
    
    func getQuotes(filterBy: QuoteCategoriesMenu?) async throws -> (quotes: [Quote], snapshots: [QueryDocumentSnapshot?])
    
    func getNewQuotes(filterBy: QuoteCategoriesMenu?, snapshots: [QueryDocumentSnapshot?]) async throws -> (quotes: [Quote], snapshots: [QueryDocumentSnapshot?])
    
    func getPreviousQuotes(filterBy: QuoteCategoriesMenu?, snapshots: [QueryDocumentSnapshot?]) async throws -> (quotes: [Quote], snapshots: [QueryDocumentSnapshot?])
}

final class QuoteSession: FSQuoteSession {
    
    let dataBase = Firestore.firestore()
    
    private var limitNumber = Constant.numberOfData
    
//    func getThemes() async throws -> [String] {
//        let docRef = dataBase.collection(DataRequest.themesCitation.rawValue)
//        var themes = [String]()
//        do {
//            let callResult = try await docRef.getDocuments()
//            themes = callResult.documents.compactMap { queryDoc in
//                let theme = try! queryDoc.data(as: String.self)
//                return theme
//            }
//        }
//        catch {
//            print(error)
//            throw error
//        }
//        return themes
//    }
    
    func getQuotes(filterBy: QuoteCategoriesMenu?) async throws -> (quotes: [Quote], snapshots: [QueryDocumentSnapshot?]) {
        
        var docRef: Query
        
        if filterBy == nil {
            docRef = dataBase.collection(DataRequest.citations.rawValue).order(by: "date", descending: true).limit(to: limitNumber)
        } else {
            docRef = dataBase.collection(DataRequest.citations.rawValue).whereField("category", isEqualTo: filterBy!.rawValue).limit(to: limitNumber)
        }
        do {
            let callResult = try await docRef.getDocuments()
            
            let quotes: [Quote] = callResult.documents.compactMap { queryDocumentSnapshot in
                let quote = try! queryDocumentSnapshot.data(as: Quote.self)
                return quote
            }
            
            let lastSnapshot = callResult.documents.last
            return (quotes: quotes, snapshots: [lastSnapshot])
        }
        catch {
            print(error)
            throw error
        }
    }
    
    func getNewQuotes(filterBy: QuoteCategoriesMenu?, snapshots: [QueryDocumentSnapshot?]) async throws -> (quotes: [Quote], snapshots: [QueryDocumentSnapshot?]) {
        
        guard let lastSnapshot = snapshots.last else {
            return (quotes: [], snapshots: [nil]) }
        
        guard let lastSnapshot = lastSnapshot else {
            return (quotes: [], snapshots: [nil]) }
        
        var newSnapshots = snapshots
        var docRef : Query
        if filterBy != nil {
            docRef = dataBase.collection(DataRequest.citations.rawValue).whereField("category", isEqualTo: filterBy!.rawValue).limit(to: limitNumber).start(atDocument: lastSnapshot)
        } else {
            docRef = dataBase.collection(DataRequest.citations.rawValue).order(by: "date", descending: true).limit(to: limitNumber).start(atDocument: lastSnapshot)
        }
        do {
            let callResult = try await docRef.getDocuments()
            
            let quotes: [Quote] = callResult.documents.compactMap { queryDocumentSnapshot in
                let quote = try! queryDocumentSnapshot.data(as: Quote.self)
                return quote
            }
            
            let newLastSnapshot = callResult.documents.last
            newSnapshots.append(newLastSnapshot)
            return (quotes: quotes, snapshots: newSnapshots)
        }
        catch {
            print("error occured")
            throw error
        }
    }
    
    func getPreviousQuotes(filterBy: QuoteCategoriesMenu?, snapshots: [QueryDocumentSnapshot?]) async throws -> (quotes: [Quote], snapshots: [QueryDocumentSnapshot?]) {
        
        var docRef: Query
        
        var currentSnapshots = snapshots
        // if number of snapshot < 3, go back implies to restart from start
        if currentSnapshots.count < 3 {
            currentSnapshots.removeAll()
            
            if filterBy == nil {
                docRef = dataBase.collection(DataRequest.citations.rawValue).order(by: "date", descending: true).limit(to: limitNumber)
            } else {
                docRef = dataBase.collection(DataRequest.citations.rawValue).whereField("category", isEqualTo: filterBy!.rawValue).limit(to: limitNumber)
            }
            // else we have to remove the 2 last (the last obtained at the end of each request)
        } else {
            currentSnapshots.removeLast()
            currentSnapshots.removeLast()
            
            if let snapshot = currentSnapshots.last  {
                if filterBy == nil {
                    docRef = dataBase.collection(DataRequest.citations.rawValue).order(by: "date", descending: true).limit(to: limitNumber).start(atDocument: snapshot!)
                } else {
                    docRef = dataBase.collection(DataRequest.citations.rawValue).whereField("category", isEqualTo: filterBy!.rawValue).limit(to: limitNumber).start(atDocument: snapshot!)
                }
            }
            else {
                if filterBy == nil {
                    docRef = dataBase.collection(DataRequest.citations.rawValue).order(by: "date", descending: true).limit(to: limitNumber)
                } else {
                    docRef = dataBase.collection(DataRequest.citations.rawValue).whereField("category", isEqualTo: filterBy!.rawValue).limit(to: limitNumber)
                }
            }
        }
        
        do {
            let callResult = try await docRef.getDocuments()
            
            let quotes : [Quote] = callResult.documents.compactMap { queryDocumentSnapshot in
                let quote = try! queryDocumentSnapshot.data(as: Quote.self)
                return quote
            }
            
            let lastSnapshot = callResult.documents.last
            currentSnapshots.append(lastSnapshot)

            return (quotes: quotes, snapshots: currentSnapshots)
        }
        catch {
            throw error
        }
    }
    
}
