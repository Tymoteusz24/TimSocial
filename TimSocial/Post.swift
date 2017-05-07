//
//  Post.swift
//  TimSocial
//
//  Created by kinia on 05.05.2017.
//  Copyright © 2017 kinia. All rights reserved.
//

import Foundation
import Firebase


class Post {
    private var _caption: String!
    private var _imgUrl: String!
    private var _likes: Int!
    private var _postKey: String!
    private var _postRef: FIRDatabaseReference!
    private var _userName: String!
    private var _profileImg: String!
    
    var profileImg: String {
        return _profileImg
    }
    
    var userName: String {
        return _userName
    }
    
    var caption: String {
        return _caption
    }
    var imgUrl: String {
        return _imgUrl
    }
    var likes: Int {
        return _likes
    }
    var postKey: String {
        return _postKey
    }
    
    init(caption: String, imageUrl: String, likes: Int) {
        self._caption = caption
        self._imgUrl = imgUrl
        self._likes = likes
    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        if let caption = postData["caption"] as? String {
            self._caption = caption
        }
        if let imgUrl = postData["imageUrl"] as? String{
            self._imgUrl = imgUrl
        }
        if let likes = postData["likes"] as? Int {
            self._likes = likes
        }
        if let profileName = postData["userName"] as? String {
            self._userName = profileName
        }
        if let profileImgUrl = postData["profileImgUrl"] as? String {
            self._profileImg = profileImgUrl
        }
        
    
        
        // dodaj pobieranie imgProfileUrl oraz tą zmienną
        
        
        _postRef = DataService.ds.REF_POSTS.child(_postKey)
        
    }
    
    func adjustLikes(addLike: Bool) {
        if addLike {
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }
        _postRef.child("likes").setValue(_likes)
    }
    
}
