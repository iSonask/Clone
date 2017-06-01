//
//  Constant.swift
//  Clone
//
//  Created by FARHAN IT SOLUTION on 31/05/17.
//
//

import Foundation


fileprivate enum SessionKey: String {
    
    case isFirstLaunch = "isFirstLaunch"
    case deviceToken = "deviceToken"
    case loggedUserID = "loggedUserID"
    case loggedUser = "loggedUser"
    
    func set(_ value: String) {
        UserDefaults.standard.set(value, forKey: rawValue)
    }
    
    func set(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: rawValue)
    }
    
    func set(_ value: Int) {
        UserDefaults.standard.set(value, forKey: rawValue)
    }
    
    func string() -> String? {
        return UserDefaults.standard.string(forKey: rawValue)
    }
    
    func bool() -> Bool {
        return UserDefaults.standard.bool(forKey: rawValue)
    }
    
    func int() -> Int {
        return UserDefaults.standard.integer(forKey: rawValue)
    }
    
}

class Session: NSObject {
    
    //This prevents others from using the default '()' initializer for this class.
    private override init(){}
    
    
    static var isFirstLaunch: Bool {
        
        get{
            let isFirstLaunch = SessionKey.isFirstLaunch
            return isFirstLaunch.bool()
        }
        
        set(value){
            let isFirstLaunch = SessionKey.isFirstLaunch
            isFirstLaunch.set(value)
        }
        
    }
    
    static var deviceToken: String {
        
        get{
            let deviceToken = SessionKey.deviceToken
            return deviceToken.string() ?? "DeviceToken"
        }
        
        set(value){
            let deviceToken = SessionKey.deviceToken
            deviceToken.set(value)
        }
        
    }
    
    static var loggedUserID: Int {
        
        get{
            let deviceToken = SessionKey.loggedUserID
            return deviceToken.int()
        }
        
        set(value){
            let deviceToken = SessionKey.loggedUserID
            deviceToken.set(value)
        }
        
    }
    
    static var isUserLoggedIn: Bool {
        return loggedUserID > 0
    }
    
    
}
