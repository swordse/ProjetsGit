//
//  DataRequest.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 01/06/2022.
//

import Foundation
/// enum to get the string to perform the FireBase request

enum DataRequest: String {
    case anecdotes = "anecdotes"
    case comments = "comments"
    case words = "words"
    case allWords = "allWords"
    case citations = "citations"
    case themesCitation = "themesCitation"
    case user = "users"
    case categoryQuizz = "categoryQuizz"
    case quizzs = "quizzs"
    case submitData = "submitData"
}
