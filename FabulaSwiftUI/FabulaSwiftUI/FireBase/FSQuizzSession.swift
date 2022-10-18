//
//  FSQuizzSession.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 30/06/2022.
//

import Foundation
import Firebase


protocol FSQuizzSession {
    
    func getCategoryQuizz(dataRequest: String, callback: @escaping ([[String : Any]]?, NetworkError?) -> Void)
    
    func getQuizzs(title: String, dataRequest: String) async throws -> ([Quizz]?, NetworkError?)
}


final class QuizzSession: FSQuizzSession {
    
    private let dataBase = Firestore.firestore()
    
    func getCategoryQuizz(dataRequest: String, callback: @escaping ([[String : Any]]?, NetworkError?) -> Void) {
        var firestoreResult = [[String: Any]]()
        let docRef = dataBase.collection(dataRequest)
        docRef.getDocuments { snapshot, error in
            guard let data = snapshot?.documents, error == nil else {
                callback(nil, NetworkError.errorOccured)
                return }
            for i in 0 ..< data.count {
                let dictionary = data[i].data()
                firestoreResult.append(dictionary)
            }
            callback(firestoreResult, nil)
        }
    }
    
    func getQuizzs(title: String, dataRequest: String) async throws -> ([Quizz]?, NetworkError?) {
        
        let docRef = dataBase.collection(dataRequest).whereField("title", isEqualTo: title)
        
        do {
            let callResult = try await docRef.getDocuments()
            let quizzs: [Quizz] = callResult.documents.map { queryDocumentSnapshot in
                let result = queryDocumentSnapshot.data()
                return Quizz(question: result["question"] as! String, answer: result["response"] as! String, propositions: result["propositions"] as! [String])
            }
            return(quizzs, nil)
        } catch {
            return(nil, NetworkError.errorOccured)
        }
    }
    
}
