//
//  String_getUrl.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 17/01/2023.
//

import Foundation

extension String {
    
    func getShortUrl() -> String {
        var result = ""
        
        if let url = URL(string: self) {
            guard let hostUrl = url.host else { return ""}
            result = hostUrl
        } else {
            if let validString = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed), let url = URL(string: validString) {
                guard let hostUrl = url.host else { return ""}
                result = hostUrl
            }
        }
        print("GETSHORTURL RESULT :\(result)")
        return result
    }
}
