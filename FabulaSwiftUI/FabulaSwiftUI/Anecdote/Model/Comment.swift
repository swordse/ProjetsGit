//
//  Comment.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 02/06/2022.
//

import Foundation
import Firebase

// struct for the comment display about anecdotes
struct Comment: Codable {
    var commentId: String
    var anecdoteId: String
    var commentText: String
    var date: Timestamp?
    var userName: String
    var userId: String
    var userImage: URL?
}
