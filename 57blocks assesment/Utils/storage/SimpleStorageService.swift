//
//  SimpleStorageService.swift
//  57blocks assesment
//
//  Created by Sergio Gelves on 14/05/21.
//

import Foundation

protocol SimpleStorageServiceProtocol {

    static var instance: SimpleStorageServiceProtocol { get }

    var userDefaults: UserDefaults { get }

    static func storeValue(withKey key: SimpleStorageKeys, andValue value: String)

    static func getValue(withKey key: SimpleStorageKeys) -> String?
}

enum SimpleStorageKeys: String {
    case login
}

class SimpleStorageService: SimpleStorageServiceProtocol {

    static let instance: SimpleStorageServiceProtocol = SimpleStorageService()

    var userDefaults: UserDefaults

    private init() {
        self.userDefaults = UserDefaults()
    }

    static func storeValue(withKey key: SimpleStorageKeys, andValue value: String) {
        SimpleStorageService.instance.userDefaults.setValue(value, forKey: key.rawValue)
    }

    static func getValue(withKey key: SimpleStorageKeys) -> String? {
        return SimpleStorageService.instance.userDefaults.string(forKey: key.rawValue)
    }
}
