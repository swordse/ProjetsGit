//
//  Credentials.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 29/10/2022.
//

import Foundation

class Credentials: Codable {
    
    var password: String
    var email: String
    
    init(password: String, email: String) {
        self.password = password
        self.email = email
    }
    
    func encoded() -> String {
        let encoder = JSONEncoder()
        let credentialsData = try! encoder.encode(self)
        return String(data: credentialsData, encoding: .utf8)!
    }
    
    static func decode(_ credentialsString: String) -> Credentials {
        let decoder = JSONDecoder()
        let jsonData = credentialsString.data(using: .utf8)
        return try! decoder.decode(Credentials.self, from: jsonData!)
    }
}
