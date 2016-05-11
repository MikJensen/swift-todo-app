//
//  TodoModel.swift
//  swift-todo-app
//
//  Created by Jógvan Olsen on 09/05/2016.
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
            for var todo in todosJson{ // <-- Annoying xcode bug (This shouldn't be a warning.)
                todos.append(self.buildTodo(todo, parent: nil))
            }
            
            ch(todos: todos)            
        }
    }
    
    func postNewTodo(title: String, date: NSDate? = nil, root: Todo? = nil, parent: Todo? = nil, ch: (todo: Todo?) -> Void){
        
        let api = "/api/todo"
        let method = "POST"
        let token = userModel.getUser().token
        
        var data = "title=\(title)"
        if let date = date{
            data = "\(data)&date=\(date)"
        }
        if let root = root{
            data = "\(data)&root=\(root)"
        }
        if let parent = parent{
            data = "\(data)&parent=\(parent)"
        }
        
        self.api.request(api: api, method: method, data: data, token: token){
            json, status in
            
        }
    }
    
    private func buildTodo(node: NSDictionary, parent: Todo?) -> Todo{
        let id = node["_id"] as! String
        let title = node["title"] as! String
        let archived = node["archived"] as! Bool
        let date = NSDate(iso8601: node["date"] as! String)
        
        let todo = Todo(id: id, title: title, archived: archived, date: date)

        todo.root = nil
        
        if let parent = parent{
            todo.parent = parent
            if let root = parent.root{
                todo.root = root
            } else{
                todo.root = parent
            }
        }
        
        for child in node["child"] as! [NSDictionary]{
            todo.addChild(buildTodo(child, parent: todo))
        }
        
        return todo
    }
    
}
