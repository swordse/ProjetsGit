//
//  CommentService.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 02/06/2022.
//

import Foundation


final class CommentService {
    
    let session: FSAnecdoteSession
    
    init(session: FSAnecdoteSession = AnecdoteSession()){
        self.session = session
    }
    
    func readComments(anecdoteId: String) async throws -> [Comment] {
        
        return try await session.readComments(dataRequest: DataRequest.comments.rawValue, anecdoteId: anecdoteId)
    }
    
    func save(commentToSave: [String: Any], completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        session.save(commentToSave: commentToSave, completion: completion)
    }
    
    func update(comment: Comment, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        session.update(comment: comment, completion: completion)
    }

}
