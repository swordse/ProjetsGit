//
//  UserDefaultsManager.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 20/06/2022.
//

import Foundation
import SwiftUI

public enum Keys {
        static let hasSeenAppIntroduction = "hasSeenAppIntroduction"
        static let currentUserSaved = "currentUserSaved"
    }


class UserDefaultsManager: ObservableObject {
    
    static let manager = UserDefaultsManager()
    
    private init() {
    }
    
    var hasSeenAppIntroduction: Bool {
            set {
                UserDefaults.standard.set(newValue, forKey: Keys.hasSeenAppIntroduction)
            }
            get {
                UserDefaults.standard.bool(forKey: Keys.hasSeenAppIntroduction)
            }
        }
    
    func saveCurrentUser(user: FabulaUser) {
        
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: Keys.currentUserSaved)
        } else {
            print("failed to encode FabulaUser for UserDefaults")
        }
    }
    
    func retrieveCurrentUser() -> FabulaUser? {
        if let data = UserDefaults.standard.data(forKey: Keys.currentUserSaved) {
            if let decoded = try? JSONDecoder().decode(FabulaUser.self, from: data) {
                return decoded
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func removeCurrentUser() {
        UserDefaults.standard.removeObject(forKey: Keys.currentUserSaved)
    }
    
}
