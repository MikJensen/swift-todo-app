//
//  UserModel.swift
//  swift-todo-app
//
//  Created by Mik Jensen on 09/05/2016.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit

class UserModel: NSObject {
    
    var user: User?

    let api = ApiModel()
    
    
    func login(username: String, password: String, ch: (success: Bool) -> Void){
        
        let api = "/api/user/login"
        let method = "POST"
        let data = "username=\(username)&password=\(password)"
        
        self.api.request(api: api, method: method, data: data){
            json, status in
            
            // TODO: If statuserror success false x2
            if status == 200{
                let api = "/api/user"
                let method = "GET"
                let token = json!["token"]! as! String
                self.api.request(api: api, method: method, data: "", token: token){
                    json, status in
                    if status == 200{
                        let fullname = json!["fullname"] as? String ?? ""
                        let age = json!["age"] as? Int ?? -1
                        
                        self.user = User(fullname: fullname, age: age, username: username, token: token)
                        self.saveKeychain()
                        ch(success: true)
                    }else{
                        ch(success: false)
                    }
                }
            }else{
                ch(success: false)
            }
        }
        
        
        
    }
    
    
    func saveKeychain(){
        if let user = user{
            // Set user object in keychain
            KeychainWrapper.setObject(user, forKey: "isLoggedIn")
        }
    }
    
    func getUser() -> User{
        // Get user object in keychain
        return KeychainWrapper.objectForKey("isLoggedIn") as! User
    }
    
}
