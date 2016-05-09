//
//  LoginViewController.swift
//  swift-todo-app
//
//  Created by Mik Jensen on 09/05/2016.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    // Set user object in keychain
    // KeychainWrapper.setObject("OBJECT", forKey: "IsLoggedIn")
    
    // Get user object in keychain
    // let userObj = KeychainWrapper.objectForKey("IsLoggedIn") as! User

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let um = UserModel()
        um.login("jeggy22", password: "password"){
            s in
            if s{
                print(um.getUser().fullname)
            }
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
