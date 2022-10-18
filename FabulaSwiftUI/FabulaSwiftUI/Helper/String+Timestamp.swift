//
//  String+Timestamp.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 07/06/2022.
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
