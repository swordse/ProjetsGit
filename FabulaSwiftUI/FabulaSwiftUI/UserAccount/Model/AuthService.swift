//
//  AuthService.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 20/06/2022.
//

import SwiftUI


class AuthService {
    
    let session: FireAuthSession
    
    init(session: FireAuthSession = AuthSession()) {
        self.session = session
    }
    
    func createAccount(userEmail: String, password: String, userName: String, userImage: UIImage?, completion: @escaping (_ photoUrl: URL?, _ userId: String?, _ error: NetworkError?) -> Void) {
        session.createAccount(userEmail: userEmail, password: password, userName: userName, userImage: userImage, completion: completion)
    }
    
    func signIn(email: String, password: String, completion: @escaping (FabulaUser?, NetworkError?) -> Void) {
        session.signIn(email: email, password: password, completion: completion)
    }
  
    func getCurrentUser() async throws -> FabulaUser? {
        return try await session.getCurrentUser()
    }
    
    func saveUser(user: FabulaUser) async {
        return await session.saveUser(user: user)
    }
    
    func logOut() {
        return session.logOut()
    }
    
    func passwordReset(email: String) -> Error? {
        return session.passwordReset(email: email)
    }
    
    func deleteUser() async throws -> ((title: String, message: String), networkError: NetworkError?) {
        return try await session.deleteUser()
    }
    
}
