//
//  Prefs.swift
//  submission-Core
//
//  Created by Ade Resie on 24/12/22.
//

import Foundation

public class Prefs {
    private init() {}
    
    public static let shared = Prefs()
    
    private let defaults = UserDefaults.standard
    
    public func getName() -> String {
        return defaults.string(forKey: Constants.name) ?? Constants.nameDefault
    }
    
    public func getEmail() -> String {
        return defaults.string(forKey: Constants.email) ?? Constants.emailDefault
    }
    
    public func saveName(value: String, key: String) {
        defaults.setValue(value, forKey: key)
    }
}
