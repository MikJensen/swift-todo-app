//
//  CreateNewUserViewController.swift
//  swift-todo-app
//
//  Created by Mik Jensen on 09/05/2016.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit

class CreateNewUserViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var fullnameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var repeatPassField: UITextField!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorMessage: UILabel!
    
    let userModel = UserModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadingIndicator.hidden = true
        errorMessage.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createUserAction(sender: AnyObject) {
        errorMessage.hidden = true
        if usernameField.text != "" && fullnameField.text != "" && ageField.text != "" && passField.text != "" && repeatPassField.text != ""{
            if passField.text == repeatPassField.text{
                loadingIndicator.hidden = false
                loadingIndicator.startAnimating()
                userModel.register(usernameField.text!, password: passField.text!, fullname: fullnameField.text!, age: Int(ageField.text!)!){
                    succes, text in
                    dispatch_async(dispatch_get_main_queue()){
                        self.loadingIndicator.hidden = true
                        self.loadingIndicator.stopAnimating()
                        if succes {
                            JLToast.makeText("Bruger er oprettet", duration: JLToastDelay.ShortDelay).show()
                            self.navigationController?.popViewControllerAnimated(true)
                        }else{
                            self.errorMessage.text = "Brugernavn allerede brugt"
                        }
                    }
                }
            }else{
                errorMessage.hidden = false
                errorMessage.text = "passwords should match"
            }
        }else{
            errorMessage.hidden = false
            errorMessage.text = "all fields should be filled"
        }
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
