//
//  Users.swift
//  TimSocial
//
//  Created by kinia on 05.05.2017.
//  Copyright © 2017 kinia. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

class Users {
    static let us = Users()
    
    private var _userUid: String!
    private var _userName: String!
    private var _userImgUrl: String!
    private var _provider: String!
    
    var provider: String{
        get{
            if _provider == nil {
                _provider = ""
            }
            return _provider
        } set {
            _provider = newValue
        }
    }
    
    var userName: String {
        get {
            if _userName == nil {
                _userName = ""
            }
            return _userName
        } set {
            _userName = newValue
        }
       
    }
    
    
    
    var userImgUrl: String {
        get {
        if _userImgUrl == nil {
            _userImgUrl = ""
        }
        return _userImgUrl!
        }
        set {
            _userImgUrl = newValue
        }
    }

    init(){
        
    }
    
    var userUid: String {
        get {
            if _userUid == nil {
                _userUid = ""
            }
            return _userUid
        } set {
           _userUid = newValue
        }

    }
    
    init(userName: String, userImgUrl: String) {
        self._userName = userName
        self._userImgUrl = userImgUrl
    }
    
    func updateUser(userKey: String, postData: Dictionary<String, AnyObject>){
        
        if let key = KeychainWrapper.standard.string(forKey: KEY_UID) {
            self._userUid = key
        }
        
        if let userName = postData["userName"] as? String {
            self._userName = userName
        }
        if let userImgUrl = postData["profileImgUrl"] as? String{
            self._userImgUrl = userImgUrl
        }
        self._userUid = userKey
    }
    
//    init(userKey: String, postData: Dictionary<String, AnyObject>) {
//        if let userName = postData["userName"] as? String {
//            self._userName = userName
//        }
//        if let userImgUrl = postData["userImgUrl"] as? String{
//            self._userImgUrl = userImgUrl
//        }
//        self._userUid = userKey
//        
//    }
//    
    
    
    
}
