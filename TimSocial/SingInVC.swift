//
//  ViewController.swift
//  TimSocial
//
//  Created by kinia on 04.05.2017.
//  Copyright © 2017 kinia. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var passwordField: FancyField!

    let key = KeychainWrapper.standard.string(forKey: KEY_UID)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
        performSegue(withIdentifier: "goToFeed", sender: AnyObject.self)
        }
    //    print("SignIN-ViewDidLoad: userName: \(Users.us.userName) userUID: \(Users.us.userUid) keyUID:  " + key!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToFeed", sender: AnyObject.self)
        }
     //   print("SignIN-ViewDidApear: userName: \(Users.us.userName) userUID: \(Users.us.userUid) keyUID: " + key!)
        
        //sprawdzenie czy jest KEYCHAIN
//            if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
//            performSegue(withIdentifier: "goToFeed", sender: AnyObject.self)
//        }
    }

   
    @IBAction func facebookPressed(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("TIM: Unable to auth with Facebook - \(String(describing: error))")
            } else if result?.isCancelled == true {
                print("TIM: USer Cancel facebook auth")
            } else {
                print("TIM: Success auth with fb")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuthenticate(credential)
            }
        }
    }
    
    
    func firebaseAuthenticate(_ credential: FIRAuthCredential){
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("TIM: Unable to auth with Firebase - \(String(describing: error))")
            } else {
                print("TIM: Succecfully auth with Firebase")
                if let user = user {
                    Users.us.userUid = user.uid
                    Users.us.provider = credential.provider
                    let _ = KeychainWrapper.standard.set(user.uid, forKey: KEY_UID)
                    self.performSegue(withIdentifier: "goToPerson", sender: AnyObject.self)
                    //let userData = ["provider": credential.provider]
                   //self.completedSignIn(id: user.uid, userData: userData)
                }
                }
        })
        
    }
    
    @IBAction func emailLoginPressed(_ sender: Any) {
        if let email = emailField.text, let pwd = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("TIMI: Email user auth with firebase")
                    if let user = user {
                        let _ = KeychainWrapper.standard.set(user.uid, forKey: KEY_UID)
                        Users.us.userUid = user.uid
                        Users.us.provider = user.providerID
                        self.performSegue(withIdentifier: "goToPerson", sender: AnyObject.self)
//                        let userData = ["provider": user.providerID]
//                        self.completedSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("Timi: Email user failed auth with FIREBASE")
                        } else {
                            print("TIMI: Succesfully created account with firebase")
                            if let user = user {
                                let _ = KeychainWrapper.standard.set(user.uid, forKey: KEY_UID)
                                Users.us.userUid = user.uid
                                Users.us.provider = user.providerID
                                self.performSegue(withIdentifier: "goToPerson", sender: AnyObject.self)
//                                let userData = ["provider" : user.providerID]
//                                self.completedSignIn(id: user.uid, userData: userData)
                            }
                            
                        }
                    })
                    
                }
            })
        }
        
    }
    
    func completedSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        let keyChainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("Timi- Data saved to keychain \(keyChainResult)")
    }
    
    func uploadUsers() {
        
        let userID = KeychainWrapper.standard.string(forKey: KEY_UID)
        
        let refUser = DataService.ds.REF_USER_CURRENT
        
        refUser.observeSingleEvent(of: .value, with: { (snapchot) in
            let value = snapchot.value as? Dictionary<String, AnyObject>
            print("TIMI: \(snapchot)")
            Users.us.updateUser(userKey: userID!, postData: value!)
            
            
            
            print("UserName:\(Users.us.userName) of user Uid: \(Users.us.userUid)")
            
        }) { ( error ) in
            print(error.localizedDescription)
        }
    }
    

    
}

