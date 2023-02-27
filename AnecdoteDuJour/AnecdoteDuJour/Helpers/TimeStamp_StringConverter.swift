//
//  TimeStamp_StringConverter.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 20/01/2023.
//

import Foundation
import Firebase

extension String {
    
    func stringToTimestamp() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.date(from: self)
    }
}
