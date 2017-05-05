//
//  DataService.swift
//  TimSocial
//
//  Created by kinia on 05.05.2017.
//  Copyright © 2017 kinia. All rights reserved.
//

import Foundation
import Firebase


//referernce to database
let DB_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()

class DataService {
    
    //global
    static let ds = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    // storage ref
    
    //private var _REF_STORAGE = STORAGE_BASE
    private var _REF_POST_IMAGES = STORAGE_BASE.child("posts-pics")
    
    var REF_POST_IMAGES: FIRStorageReference {
        return _REF_POST_IMAGES
    }
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    
    
    
    
    
    
    
    
}
