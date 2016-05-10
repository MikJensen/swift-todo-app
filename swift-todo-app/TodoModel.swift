//
//  TodoModel.swift
//  swift-todo-app
//
//  Created by Mik Jensen on 09/05/2016.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit

class TodoModel: NSObject {
    
    let userModel: UserModel
    let api = ApiModel()
    
    init(userModel: UserModel){
        self.userModel = userModel
    }
    
    func getTodos(ch: (todos: [Todo]) -> Void){
        let api = "/api/todo"
        let method = "GET"
        let data = ""
        let token = userModel.getUser().token
        
        self.api.request(api: api, method: method, data: data, token: token){
            json, status in
            
            
            let todosJson = json!["todos"]! as! [NSDictionary]
            var todos: [Todo] = []
            for var todo in todosJson{
                todos.append(self.buildTodos(nil, parent: todo))
            }
        }
    }
    
    func buildTodos(node: NSDictionary?, parent: NSDictionary) -> Todo{
        
        
    }
    
}
