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

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("Tim")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
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
                   self.completedSignIn(id: user.uid)
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
                        self.completedSignIn(id: user.uid)
                    }
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("Timi: Email user failed auth with FIREBASE")
                        } else {
                            print("TIMI: Succesfully created account with firebase")
                            if let user = user {
                                self.completedSignIn(id: user.uid)
                            }
                            
                        }
                    })
                    
                }
            })
        }
        
    }
    
    func completedSignIn(id: String) {
        let keyChainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("Timi- Data saved to keychain \(keyChainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }

}

