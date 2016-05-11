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
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var userModel = UserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if KeychainWrapper.objectForKey("user") != nil{
            dispatch_async(dispatch_get_main_queue()){
                self.performSegueWithIdentifier("segueLogin", sender: self)
            }
        }
        
        errorMessageLabel.hidden = true
        setLoading(false)
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
            success in
            dispatch_async(dispatch_get_main_queue()){
                self.setLoading(false)
                if success{
                    self.performSegueWithIdentifier("segueLogin", sender: self)
                }else{
                    self.errorMessageLabel.hidden = false
                    self.errorMessageLabel.text = "Username or password is wrong."
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
