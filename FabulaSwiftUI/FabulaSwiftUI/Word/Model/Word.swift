//
//  Word.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 28/06/2022.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

// class for the word display
struct Word: Codable, Equatable {
    
    var word: String = ""
    var definition: String = ""
    var qualifier: String = ""
    var example: String = ""
    var isFavorite: Bool = false
    
}

final class WordsForLetter: Codable, Equatable {
    static func == (lhs: WordsForLetter, rhs: WordsForLetter) -> Bool {
        lhs.words == rhs.words && lhs.letter == rhs.letter
    }
    
    var letter: String
    var words: [String]
    
    init(letter: String = "", words: [String] = []) {
        self.letter = letter
        self.words = words
    }
}

final class WordState {
    var words: [Word]
    var snapshots: [QueryDocumentSnapshot?]
    var page: Int
    
    init(words: [Word], snapshots: [QueryDocumentSnapshot?], page: Int) {
        self.words = words
        self.snapshots = snapshots
        self.page = page
    }
    
}
