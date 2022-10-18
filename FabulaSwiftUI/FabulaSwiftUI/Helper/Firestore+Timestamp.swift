//
//  Firestore+Timestamp.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 07/06/2022.
//

import Foundation
import Firebase

extension Timestamp {
    
    func transformTimeStampToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        let date = self.dateValue()
        return formatter.string(from: date)
    }
    
}
