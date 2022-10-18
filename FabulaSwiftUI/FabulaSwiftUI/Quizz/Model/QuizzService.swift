//
//  QuizzService.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 30/06/2022.
//

import Foundation
import Firebase

final class QuizzService {
    
    let session: FSQuizzSession
    
    init(session: FSQuizzSession = QuizzSession()) {
        self.session = session
    }
    
    func getCategoryQuizz(callback: @escaping (Result<[[String: Any]], NetworkError>) -> Void) {
        session.getCategoryQuizz(dataRequest: DataRequest.categoryQuizz.rawValue) { result, error in
            if error != nil {
                callback(.failure(NetworkError.errorOccured))
            } else if result != nil {
                callback(.success(result!))
            }
        }
    }
    
    func getQuizzs(title: String) async throws -> ([Quizz]?, NetworkError?) {
        
        return try await session.getQuizzs(title: title, dataRequest: DataRequest.quizzs.rawValue)
    }
    
}

