//
//  UserDefaultsManager.swift
//  TrackStack
//
//  Created by Yehor Levchenko on 4/18/19.
//  Copyright © 2019 Yehor Levchenko. All rights reserved.
//

import Foundation

class UserDefaultsManager {
    
    private static let launchedOnceKey = "launchedOnce"
    private static let biometricLockKey = "biometricLock"
    static let changeableSettings = [UserDefaultsManager.biometricLock, UserDefaultsManager.launchedOnce]
    
    static var launchedOnce: Bool {
        get {
            return UserDefaults.standard.bool(forKey: launchedOnceKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: launchedOnceKey)
        }
    }
    
    static var biometricLock: Bool {
        get {
            return UserDefaults.standard.bool(forKey: biometricLockKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: biometricLockKey)
        }
    }
}
