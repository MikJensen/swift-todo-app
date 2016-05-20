//
//  LoginViewController.swift
//  swift-todo-app
//
//  Created by Mik Jensen on 09/05/2016.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit


class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    
    var userModel = UserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.roundCorners(.AllCorners, radius: 10)
        registerButton.roundCorners(.AllCorners, radius: 10)
        
        if userModel.getUser() != nil{
            dispatch_async(dispatch_get_main_queue()){
                self.performSegueWithIdentifier("segueLogin", sender: self)
            }
        }
        
        errorMessageLabel.hidden = true
        setLoading(false)
        
        // Facebook login
        let fbLoginBtn: FBSDKLoginButton = {
            permissions in
            let button = FBSDKLoginButton()
            button.readPermissions = permissions
            return button
        }(["email"])
        
        self.view.addSubview(fbLoginBtn)
        fbLoginBtn.center = view.center
        fbLoginBtn.delegate = self
        if let _ = FBSDKAccessToken.currentAccessToken(){
            print("Is already logged in.")
        }

    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("Logged in!")
        
        let parameters = ["fields": "email, first_name, last_name, picture"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler{
            connection, result, error in
            if error != nil{
                print(error.description)
                return
            }
            
            if let email = result["email"] as? String{
                print(email)
            }else{
                print("User didn't allow email permission.")
            }
            
        }
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        print("Logging in")
        return true
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("Logged out!")
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueLogin"{
            let destinationController = segue.destinationViewController as! TabBarViewController
            destinationController.userModel = self.userModel
        }
    }
    
    @IBAction func loginPressed(sender: UIButton) {
        setLoading(true)
        userModel.login(usernameField.text!, password: passwordField.text!){
            success, errorMessage in
            dispatch_async(dispatch_get_main_queue()){
                self.setLoading(false)
                if success{
                    self.performSegueWithIdentifier("segueLogin", sender: self)
                }else{
                    self.errorMessageLabel.hidden = false
                    self.errorMessageLabel.text = errorMessage
                }
            }
        }
    }
    
    @IBAction func registerPressed(sender: UIButton) {
        performSegueWithIdentifier("segueRegister", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setLoading(loading: Bool){
        dispatch_async(dispatch_get_main_queue()){
            if loading{
                self.errorMessageLabel.hidden = true
                self.loadingIndicator.hidden = false
                self.loadingIndicator.startAnimating()
            }else{
                self.loadingIndicator.hidden = true
                self.loadingIndicator.stopAnimating()
            }
        }
    }
}
