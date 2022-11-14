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
            guard let result = callResult.documents.first?.data() else { return (nil, NetworkError.errorOccured) }
            let questions = result["questions"] as! [String]
            let propositions = result["propositions"] as! [[String: String]]
            let answers = result["responses"] as! [String]
                
            var quizzs = [Quizz]()
                
            for index in 0..<questions.count {
                    let question = questions[index]
                    let answer = answers[index]
                    var resultProps = [String]()
                    
                    for key in 0..<3 {
                        guard let prop = propositions[index]["\(key)"] else { return (nil, NetworkError.errorOccured) }
                        resultProps.append(prop)
                    }
                    
                    quizzs.append(Quizz(question: question, answer: answer, propositions: resultProps))
                }
                return (quizzs, nil)
            } catch {
                        return(nil, NetworkError.errorOccured)
                    }
    }
    
}
