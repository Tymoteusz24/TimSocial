//
//  FeedVC.swift
//  TimSocial
//
//  Created by kinia on 05.05.2017.
//  Copyright © 2017 kinia. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        

        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        return tableView.dequeueReusableCell(withIdentifier: "FeedCell") as! FeedCell
        
    }
    
    

//    @IBAction func signOutPressed(_ sender: Any) {
//        let keyChainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
//        print("TIMI: ID removed from keychain \(keyChainResult)")
//        try! FIRAuth.auth()?.signOut()
//        performSegue(withIdentifier: "signOut", sender: nil)
//
//    }

}
