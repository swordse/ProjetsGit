//
//  String_OpenUrl.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 17/01/2023.
//

import Foundation
import SwiftUI

extension String {
    
    func openUrl() {
        
//        guard let stringUrl = self else { return }
        if let url = URL(string: self) {
            UIApplication.shared.open(url)
        } else {
            if let validString = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed), let url = URL(string: validString) {
                UIApplication.shared.open(url)
            }
        }
        
    }
    
    
}
