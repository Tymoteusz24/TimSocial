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

class SignInVC: UIViewController {
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var passwordField: FancyField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            }
        })
        
    }
    
    @IBAction func emailLoginPressed(_ sender: Any) {
        if let email = emailField.text, let pwd = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("TIMI: Email user auth with firebase")
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("Timi: Email user failed auth with FIREBASE")
                        } else {
                            print("TIMI: Succesfully created account with firebase")
                        }
                    })
                    
                }
            })
        }
        
    }
    

}

