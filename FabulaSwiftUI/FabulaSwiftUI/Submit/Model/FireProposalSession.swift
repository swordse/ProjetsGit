//
//  FireProposalSession.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 23/06/2022.
//

import Foundation
import Firebase

protocol FireProposalSession {
    
    func saveProposal(data: [String: Any], completion: @escaping (NetworkError?) -> Void)
    
}

final class ProposalSession: FireProposalSession {
    
    let dataBase = Firestore.firestore()
    
    func saveProposal(data: [String: Any], completion: @escaping (NetworkError?) -> Void) {
        dataBase.collection("SubmitProposal").document().setData(data) { error in
            if error != nil {
                completion(NetworkError.errorOccured)
            } else {
                completion(nil)
            }
        }
    }
}

class FireProposalService {
    
    let session: FireProposalSession
    
    init(session: FireProposalSession = ProposalSession()) {
        self.session = session
    }
    
    func saveProposal(data: [String: Any], completion: @escaping (NetworkError?) -> Void) {
        
        session.saveProposal(data: data, completion: completion)
    }
}
