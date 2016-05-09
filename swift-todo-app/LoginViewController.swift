//
//  LoginViewController.swift
//  swift-todo-app
//
//  Created by Mik Jensen on 09/05/2016.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let api = ApiModel(url: "http://194.239.172.19")
        
        //let object = "username=jeggy&password=password"
        let token = "JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6ImplZ2d5IiwicGFzc3dvcmQiOiIkMmEkMTAkNGhLeE1vVEduRzZQNVBjZ2pJU1dpZVo3RHkuOVJuVi8yMFA4N2tQcHA3bktNNDZVeG8yTHEiLCJfaWQiOiI1NzJlNDc0YWNiODkyZjliNzc5Y2Y3YjciLCJfX3YiOjB9.qKeUdL-ch9G6RE_eYaaNvutvXOICSqCabRt4zOTTtcI"
        
        api.request(api: "/api/todo", method: "GET", data: "", token: token){
            json, status in
            print("status: \(status) json: \(json)")
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
