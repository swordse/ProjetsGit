//
//  FabulaUser.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 20/06/2022.
//

import Foundation

struct FabulaUser: Equatable, Codable {
    
    var userName: String
    var userId: String
    var userEmail: String
    var userImage: URL?
    
    static func == (lhs: FabulaUser, rhs: FabulaUser) -> Bool {
        return lhs.userName == rhs.userName &&
        lhs.userId == rhs.userId &&
        lhs.userEmail == rhs.userEmail && lhs.userImage == rhs.userImage
    }
}
