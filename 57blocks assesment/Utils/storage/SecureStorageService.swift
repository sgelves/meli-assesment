//
//  SecureStorageService.swift
//  57blocks assesment
//
//  Created by Sergio Gelves on 14/05/21.
//

import Foundation
import Security

protocol SecureStorageServiceProtocol {

    static var instance: SecureStorageServiceProtocol { get }

    static var domain: String { get }

    static func storeValue(withKey key: SecureStorageKeys, andValue value: String) throws -> String?

    static func getValue(withKey key: SecureStorageKeys) throws -> String?
}

enum SecureStorageKeys: String {
    case token
}

class SecureStorageService: SecureStorageServiceProtocol {

    static let instance: SecureStorageServiceProtocol = SecureStorageService()

    static let domain = "com.57blocksassesment.co."

    private init() {}

    static func storeValue(withKey key: SecureStorageKeys, andValue value: String) throws -> String? {

        let tag = "\(domain)\(key.rawValue)".data(using: .utf8)!
        let addquery: [String: Any] = [
            kSecClass as String: value.data(using: .utf8)!,
            kSecAttrApplicationTag as String: tag,
            kSecValueRef as String: key
        ]

        var ref: AnyObject?

        let status = SecItemAdd(addquery as CFDictionary, &ref)
        guard status == errSecSuccess else { throw NSError() }

        let result = ref as! Data
        return String(data: result, encoding: .utf8)!
    }

    static func getValue(withKey key: SecureStorageKeys) throws -> String? {

        let tag = "\(domain)\(key.rawValue)".data(using: .utf8)!
        let getquery: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tag,
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecReturnRef as String: true
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(getquery as CFDictionary, &item)
        guard status == errSecSuccess else { throw NSError() }

        let data = item as! Data
        let value = String(data: data, encoding: .utf8)!

        return value
    }
}
