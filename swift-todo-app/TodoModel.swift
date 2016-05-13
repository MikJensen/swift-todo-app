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
        let token = userModel.user?.token ?? ""
        
        self.api.request(api: api, method: method, data: data, token: token){
            json, status in
            
            if status == 200{
                let todosJson = json!["todos"]! as! [NSDictionary]
                var todos: [Todo] = []
                for var todo in todosJson{ // <-- Annoying xcode bug (This shouldn't be a warning.)
                    todos.append(self.buildTodo(todo, parent: nil))
                }
                ch(todos: todos)
            }else{
                ch(todos: [])
            }
            
        }
    }
    
    func postNewTodo(title: String, date: NSDate? = nil, root: Todo? = nil, parent: Todo? = nil, ch: (todo: Todo?) -> Void){
        
        let api = "/api/todo"
        let method = "POST"
        let token = userModel.user?.token ?? ""
        
        var data = "title=\(title)"
        if let date = date{
            data = "\(data)&date=\(date.toIsoString())"
        }
        if let root = root{
            data = "\(data)&root=\(root.id)"
        }
        if let parent = parent{
            data = "\(data)&parent=\(parent.id)"
        }
        
        self.api.request(api: api, method: method, data: data, token: token){
            json, status in
            
            if status == 200{
                let id = json!["_id"] as! String
                let archived = json!["archived"] as! Bool
                // let date = NSDate(iso8601: json!["date"] as! String) // Bug in server
                
                let newTodo = Todo(id: id, title: title, archived: archived, date: date ?? NSDate(), parent: parent, root: root)
                ch(todo: newTodo)
            } else{
                // Status = 400(Bad Request) and maybe other errors
                ch(todo: nil)
            }
            
        }
    }
    
    // Idea for this function: https://gist.github.com/jeggy/26e0b099d5e5bb6ee0eefd0988af13e2
    func removeTodo(todo: Todo, Ch: (success: Bool) -> Void){
        let api = "/api/todo/\(todo.id)"
        let method = "DELETE"
        let data = ""
        let token = self.userModel.user?.token ?? ""
        
        self.api.request(api: api, method: method, data: data, token: token){
            json, status in
            if status == 200{
                Ch(success: true)
            }else{
                Ch(success: false)
            }
        }
    }
    
    func updateTodo(todo: Todo, ch: (success: Bool) -> Void){
        let api = "/api/todo"
        let method = "PUT"
        let token = userModel.user?.token ?? ""
        let data = "id=\(todo.id)&title=\(todo.title)&date=\(todo.date.toIsoString())&archived=\(todo.archived)"
        
        self.api.request(api: api, method: method, data: data, token: token){
            ch(success: $1 == 200 ? true : false) // Using $1 just for show off :P
        }
    }
    
    private func buildTodo(node: NSDictionary, parent: Todo?) -> Todo{
        let id = node["_id"] as! String
        let title = node["title"] as! String
        let archived = node["archived"] as! Bool
        let date = NSDate(iso8601: node["date"] as! String)
        
        let todo = Todo(id: id, title: title, archived: archived, date: date)

        //todo.root = nil
        
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
