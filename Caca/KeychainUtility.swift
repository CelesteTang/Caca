//
//  KeychainUtility.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/5/4.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import Foundation

class KeychainUtility: NSObject {

    private var service = ""
    private var group = ""

    init(service: String, group: String) {
        super.init()
        self.service = service
        self.group = group
    }

    private func prepareDic(key: String) -> [String: Any] {
        var dic = [String: Any]()
        dic[kSecClass as String] = kSecClassGenericPassword
        dic[kSecAttrService as String] = self.service
        dic[kSecAttrAccessGroup as String] = self.group
        dic[kSecAttrAccount as String] = key
        return dic
    }

    func insert(data: NSData, key: String) -> Bool {
        var dic = prepareDic(key: key)
        dic[kSecValueData as String] = data
        let status = SecItemAdd(dic as CFDictionary, nil)
        if status == errSecSuccess {
            return true
        } else {
            return false
        }
    }

    func query(key: String) -> NSData? {
        var dic  = prepareDic(key: key)
        dic[kSecReturnData as String] = kCFBooleanTrue
        var data: AnyObject?
        let status = withUnsafeMutablePointer(to: &data) {
            SecItemCopyMatching(dic as CFDictionary, UnsafeMutablePointer($0))
        }
        if status == errSecSuccess {
            return data as? NSData
        } else {
            return nil
        }
    }

    func update(data: NSData, key: String) -> Bool {
        let query = prepareDic(key: key)
        var dic  = [String: AnyObject]()
        dic[kSecValueData as String] = data
        let status = SecItemUpdate(query as CFDictionary, dic as CFDictionary)
        if status == errSecSuccess {
            return true
        } else {
            return false
        }
    }

    func deleteData(key: String) -> Bool {
        let dic = prepareDic(key: key)
        let status = SecItemDelete(dic as CFDictionary)
        if status == errSecSuccess {
            return true
        } else {
            return false
        }
    }
}
