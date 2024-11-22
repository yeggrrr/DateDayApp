//
//  UserDefaultsManager.swift
//  DateDayApp
//
//  Created by YJ on 8/17/24.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    var wrappedValue: T {
        get {
            guard let wrappedValue = UserDefaults.standard.object(forKey: key) as? T else { return defaultValue }
            return wrappedValue
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private init() { }
    
    @UserDefault(key: "accessToken", defaultValue: "")
    var token: String
    
    @UserDefault(key: "refreshToken", defaultValue: "")
    var refresh: String
    
    @UserDefault(key: "saveTime", defaultValue: "")
    var saveTime: String
    
    @UserDefault(key: "saveUserID", defaultValue: "")
    var saveLoginUserID: String
    
    @UserDefault(key: "isChangedPostData", defaultValue: false)
    var isChangedPostData: Bool
}
