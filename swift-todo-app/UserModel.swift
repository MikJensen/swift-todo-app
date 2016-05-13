//
//  UserModel.swift
//  swift-todo-app
//
//  Created by Jógvan Olsen on 09/05/2016.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit

class UserModel: NSObject {
    
    var user: User?

    let api = ApiModel()
    
    
    func login(username: String, password: String, ch: (success: Bool, text: String) -> Void){
        
        let api = "/api/user/login"
        let method = "POST"
        let data = "username=\(username)&password=\(password)"
        
        self.api.request(api: api, method: method, data: data){
            json, status in
            if status == 200{
                if json!["success"]! as! Bool{
                    self.loadUserInfo(json!["token"]! as! String, ch: ch)
                }else{
                    ch(success: false, text: "Brugernavn eller kodeord er forket.")
                }
            }else{
                ch(success: false, text: "Kunne ikke connecte til serveren.")
            }
        }
    }
    
    func register(username: String, password: String, fullname: String, age: Int, ch: (success: Bool, text: String?) -> Void){
        let api = "/api/user/register"
        let method = "POST"
        let data = "username=\(username)&password=\(password)&fullname=\(fullname)&age=\(age)"
        
        self.api.request(api: api, method: method, data: data){
            json, status in
            if status == 200{
                if (json!["success"]! as! Bool) == true{
                    // TODO: Maybe do a autologin here?
                    ch(success: true, text: nil)
                }else{
                    let msg = json!["msg"]! as! String
                    ch(success: false, text: msg)
                }
            }else{
                // status -1
                ch(success: false, text: "Kunne ikke connecte til serveren.")
            }
        }
    }
    
    private func loadUserInfo(token: String, ch: (success: Bool, text: String) -> Void){
        let api = "/api/user"
        let method = "GET"
        self.api.request(api: api, method: method, data: "", token: token){
            json, status in
            if status == 200{
                let username = json!["username"] as! String
                let fullname = json!["fullname"] as? String ?? ""
                let age = json!["age"] as? Int ?? -1
                
                self.user = User(fullname: fullname, age: age, username: username, token: token)
                self.saveKeychain(self.user!)
                ch(success: true, text: "")
            }else{
                ch(success: false, text: "Kunne ikke connecte til serveren.")
            }
        }
    }
    
    func saveKeychain(user: User){
        // Set user object in keychain
        KeychainWrapper.setObject(user, forKey: "user")
    }
    
    func getUser() -> User?{
        // Get user object in keychain
        self.user = KeychainWrapper.objectForKey("user") as? User
        return self.user
    }
    
}
