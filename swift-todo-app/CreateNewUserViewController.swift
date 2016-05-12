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
    
    let userModel = UserModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createUserAction(sender: AnyObject) {
        if usernameField.text != "" && fullnameField.text != "" && ageField.text != "" && passField.text != "" && repeatPassField.text != ""{
            if passField.text == repeatPassField.text{
                userModel.register(usernameField.text!, password: passField.text!, fullname: fullnameField.text!, age: Int(ageField.text!)!){
                    succes, text in
                    if succes {
                        print("Registration enden with: \(succes) succes")
                    }else{
                        print("user could not be registered")
                        // user could not be registered
                    }
                }
            }else{
                print("passwords should match")
                // passwords should match
            }
        }else{
            print("all fields should be filled")
            // all fields should be filled
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
