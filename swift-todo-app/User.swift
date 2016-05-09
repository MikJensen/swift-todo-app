//
//  User.swift
//  swift-todo-app
//
//  Created by Mik Jensen on 09/05/2016.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit

class User: NSObject, NSCoding {
    let fullname: String
    let age: NSDate
    let username: String
    let token: String
    
    init(fullname: String, age: NSDate, username: String, token: String){
        self.fullname = fullname
        self.age = age
        self.username = username
        self.token = token
    }
    
    func getFullname()->String{
        return self.fullname
    }
    func getAge()->NSDate{
        return self.age
    }
    func getUsername()->String{
        return self.username
    }
    func geToken()->String{
        return self.token
    }
    
    // MARK: NSCoding
    
    required convenience init?(coder decoder: NSCoder)
    {
        guard let fullname = decoder.decodeObjectForKey("fullname") as? String,
            let age = decoder.decodeObjectForKey("age") as? NSDate,
            let username = decoder.decodeObjectForKey("username") as? String,
            let token = decoder.decodeObjectForKey("token") as? String
            else
        {
            return nil
        }
        
        self.init(fullname: fullname, age: age, username: username, token: token)
    }
    
    func encodeWithCoder(coder: NSCoder)
    {
        coder.encodeObject(self.fullname, forKey: "fullname")
        coder.encodeObject(self.age, forKey: "age")
        coder.encodeObject(self.username, forKey: "username")
        coder.encodeObject(self.token, forKey: "token")
    }
}
