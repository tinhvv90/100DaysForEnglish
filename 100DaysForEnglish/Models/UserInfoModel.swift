//
//  UserInfoModel.swift
//  100DaysForEnglish
//
//  Created by Vu Tinh on 2/23/17.
//  Copyright © 2017 Vu Tinh. All rights reserved.
//

import Foundation
import UIKit

public enum AccountType: Int {
    case none
    case facebook
    case google
}

class UserInfoModel: NSObject {
    
    var name = ""
    var email = ""
    var idToken = ""
    var userId = ""
    var givenName = "" // Firstname
    var familyName = "" // Lastname
    var avatarUrl = ""
    var type: AccountType = .none
    
    convenience init(name: String, email: String, idToken: String, givenName: String, familyName: String, type: AccountType, avatarUrl: String, userId: String) {
        self.init()
        self.email = email
        self.name = name
        self.idToken = idToken
        self.givenName = givenName
        self.familyName = familyName
        self.type = type
        self.avatarUrl = avatarUrl
    }
    
    func saveToUserDefault() {
        idToken.saveToUserDefaults(withKey: UserDefaultKey.deviceToken)
        name.saveToUserDefaults(withKey: UserDefaultKey.name)
        email.saveToUserDefaults(withKey: UserDefaultKey.email)
        userId.saveToUserDefaults(withKey: UserDefaultKey.userId)
        givenName.saveToUserDefaults(withKey: UserDefaultKey.givenName)
        familyName.saveToUserDefaults(withKey: UserDefaultKey.familyName)
        avatarUrl.saveToUserDefaults(withKey: UserDefaultKey.avatarImage)
        type.rawValue.saveToUserDefaults(withKey: UserDefaultKey.type)
    }
    
    static let sharedInstance : UserInfoModel = {
        var userInfo = UserInfoModel()
        if String.loadFromUserDefaults(withKey: UserDefaultKey.deviceToken) != "" {
            userInfo.loadFromUserDefault()
        } else {
            userInfo.saveToUserDefault()
        }
        return userInfo
    }()
    
    func loadFromUserDefault() {
        email = String.loadFromUserDefaults(withKey: UserDefaultKey.email)
        name = String.loadFromUserDefaults(withKey: UserDefaultKey.name)
        userId = String.loadFromUserDefaults(withKey: UserDefaultKey.userId)
        idToken = String.loadFromUserDefaults(withKey: UserDefaultKey.deviceToken)
        givenName = String.loadFromUserDefaults(withKey: UserDefaultKey.givenName)
        familyName = String.loadFromUserDefaults(withKey: UserDefaultKey.familyName)
        avatarUrl = String.loadFromUserDefaults(withKey: UserDefaultKey.avatarImage)
        let intType = Int.loadFromUserDefaults(withKey: UserDefaultKey.type)
        type = AccountType(rawValue:  intType) ?? .none
    }
    
}

extension UIImage {
    func saveToUserDefaults(withKey key: String) {
        let data = UIImagePNGRepresentation(self)
        let stringBase64 = data?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        stringBase64?.saveToUserDefaults(withKey: key)
    }
    
    static func loadFromUserDefaults(withKey key: String) -> UIImage? {
        let stringBase64 = String.loadFromUserDefaults(withKey: key)
        if let data = NSData(base64EncodedString: stringBase64, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters) {
            return UIImage(data: data)
        }
        return nil
    }
}


extension Double {
    func saveToUserDefaults(withKey key: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setDouble(self, forKey: key)
        defaults.synchronize()
    }
    static func loadFromUserDefaults(withKey key: String) -> Double {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.doubleForKey(key)
    }
}

extension Float {
    func saveToUserDefaults(withKey key: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setFloat(self, forKey: key)
        defaults.synchronize()
    }
    static func loadFromUserDefaults(withKey key: String) -> Float {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.floatForKey(key)
    }
}

extension Bool {
    func saveToUserDefaults(withKey key: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(self, forKey: key)
        defaults.synchronize()
    }
    static func loadFromUserDefaults(withKey key: String) -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.boolForKey(key)
    }
}

extension String {
    func saveToUserDefaults(withKey key: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if String.loadFromUserDefaults(withKey: key) != "" {
            defaults.setObject(nil, forKey: key)
        }
        defaults.setObject(self, forKey: key)
        defaults.synchronize()
    }
    static func loadFromUserDefaults(withKey key: String) -> String {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.stringForKey(key) ?? ""
    }
    
}

extension NSURL {
    func saveToUserDefaults(withKey key: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setURL(self, forKey: key)
        defaults.synchronize()
    }
    static func loadFromUserDefaults(withKey key: String) -> NSURL? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.URLForKey(key)
    }
    
}

extension NSData {
    func saveToUserDefaults(withKey key: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(self, forKey: key)
        defaults.synchronize()
    }
    static func loadFromUserDefaults(withKey key: String) -> NSData? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.dataForKey(key)
    }
}

extension Int {
    func saveToUserDefaults(withKey key: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(self, forKey: key)
        defaults.synchronize()
    }
    static func loadFromUserDefaults(withKey key: String) -> Int {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.integerForKey(key)
    }
}
