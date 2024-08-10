//
//  UserDefaultsManager.swift
//  AppStoreProject
//
//  Created by Joy Kim on 8/11/24.
//

import Foundation

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    private init() {}
    
    static var searchWord: String {
        get {
            return UserDefaults.standard.string(forKey: "searchWord") ?? ""
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "searchWord")
        }
    }
}
