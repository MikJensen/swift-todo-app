//
//  LoginViewController.swift
//  swift-todo-app
//
//  Created by Mik Jensen on 09/05/2016.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var userModel = UserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let um = UserModel()
        um.login("jeggy22", password: "password"){
            if $0{
                print(um.getUser().fullname)
            }
        }
    }

    @IBAction func loginPressed(sender: UIButton) {
        userModel.login(usernameField.text!, password: passwordField.text!){
            success in
            if success{
                print("Login!")
            }else{
                print("Username or password is wrong.")
            }
        }
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
