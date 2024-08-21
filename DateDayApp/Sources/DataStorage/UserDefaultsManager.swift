//
//  UserDefaultsManager.swift
//  DateDayApp
//
//  Created by YJ on 8/17/24.
//

import Foundation

final class UserDefaultsManager {
    private enum UserDefaultKey: String {
        case access
        case refresh
        case saveTime
    }
    
    static let shared = UserDefaultsManager()
    
    private init() { }
    
    var token: String {
        get {
            UserDefaults.standard.string(forKey: UserDefaultKey.access.rawValue) ?? ""
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKey.access.rawValue)
        }
    }
    
    var refresh: String {
        get {
            UserDefaults.standard.string(forKey: UserDefaultKey.refresh.rawValue) ?? ""
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKey.refresh.rawValue)
        }
    }
    
    var saveTime: String {
        get {
            UserDefaults.standard.string(forKey: UserDefaultKey.saveTime.rawValue) ?? ""
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKey.saveTime.rawValue)
        }
    }
}
