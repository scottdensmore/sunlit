//
//  Settings.swift
//  Sunlit
//
//  Created by Jonathan Hays on 5/3/20.
//  Copyright © 2020 Micro.blog, LLC. All rights reserved.
//

import Foundation
import Snippets
import UUSwift

class Settings {

    static private let shared = UserDefaults(suiteName: "group.blog.micro.sunlit")!

    static func bool(forKey key: String) -> Bool {
        return self.object(forKey: key) as? Bool ?? false
    }

    static func object(forKey key : String) -> Any? {
        if let object = Settings.shared.object(forKey: key) {
            return object
        }

        if let object = UserDefaults.standard.object(forKey: key) {
            Settings.shared.setValue(object, forKey: key)
            return object
        }

        return nil
    }

    static func removeObject(forKey key : String) {
        Settings.shared.removeObject(forKey: key)
        UserDefaults.standard.removeObject(forKey: key)
    }

    static func setValue(_ object : Any?, forKey key : String) {
        Settings.shared.setValue(object, forKey: key)
    }

	static func getInsecureString(forKey key : String) -> String {
        if let value = Settings.shared.string(forKey: key) {
            return value
        }

        if let value = UserDefaults.standard.string(forKey: key) {
            // If we got here, it means we need to migrate the key to the shared keychain...
            Settings.shared.setValue(value, forKey: key)
            return value
        }

        return ""
	}
	
	static func setInsecureString(_ value : String, forKey key : String) {
        Settings.shared.setValue(value, forKey: key)
	}
	
	static func deleteInsecureString(forKey key : String) {
        Settings.shared.removeObject(forKey: key)
		UserDefaults.standard.removeObject(forKey: key)
	}
	
	static func getInsecureDictionary(forKey key : String) -> [String : Any]? {
        if let dictionary = Settings.shared.object(forKey: key) as? [String : Any] {
            return dictionary
        }

        if let dictionary = UserDefaults.standard.object(forKey: key) as? [String : Any] {
            // If we got here, it means there is a setting to migrate...
            Settings.shared.set(dictionary, forKey: key)
            return dictionary
        }

        return nil
	}
	
	static func setInsecureDictionary(_ dictionary : [String : Any], forKey : String) {
		Settings.shared.set(dictionary, forKey: forKey)
	}
	
	static func setSecureString(_ value : String, forKey : String) {
		UUKeychain.saveString(key: forKey, acceessLevel: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly, string: value)
	}
	
	static func getSecureString(forKey : String) -> String? {
		return UUKeychain.getString(key: forKey)
	}
	
	static func deleteSecureString(forKey : String) {
		UUKeychain.remove(key: forKey)
	}
	
	/*/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	MARK: -
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////// */

	
	static func logout() {
		Settings.deleteSnippetsToken()
		SnippetsUser.deleteCurrentUser()
        Snippets.Configuration.timeline = Snippets.Configuration.microblogConfiguration(token: "")
        Snippets.Configuration.publishing = Snippets.Configuration.timeline

        BlogSettings.deleteTimelineInfo()
        BlogSettings.deletePublishingInfo()
	}
	
	static func saveSnippetsToken(_ token : String) {
		//UUKeychain.saveString(key: "SunlitToken", acceessLevel: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly, string: token)
		setValue(token, forKey: "SunlitToken")
	}

	static func snippetsToken() -> String? {
		//return UUKeychain.getString(key: "SunlitToken")
		return object(forKey: "SunlitToken") as? String
	}

	static func deleteSnippetsToken() {
        deleteInsecureString(forKey: "SunlitToken")
	}

}

