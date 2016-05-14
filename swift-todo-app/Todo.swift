//
//  Todo.swift
//  swift-todo-app
//
//  Created by Jógvan Olsen on 5/10/16.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit
import CoreData

class Todo: NSManagedObject {
    
    static var managedContext: NSManagedObjectContext!
    static var todos:[Todo] = []
    
    @NSManaged var id: String
    @NSManaged var title: String
    @NSManaged var archived: Bool
    @NSManaged var date: NSDate
    
    @NSManaged var parent: Todo?
    @NSManaged var root: Todo?
    var children: NSSet?
    
    static func buildTodo(id:String, title: String, date: NSDate, archived: Bool, parent: Todo? = nil, root: Todo? = nil) -> Todo{
        let todo = NSEntityDescription.insertNewObjectForEntityForName("Todo", inManagedObjectContext: managedContext) as! Todo
        todo.id = id
        todo.title = title
        todo.date = date
        todo.archived = archived
        
        if parent != nil && root != nil{
            todo.parent = parent!
            todo.root = root!
            todo.parent!.addChild(todo)
        }else{
            todos.append(todo)
        }
        
        return todo
    }
    
    static func loadAll(){
        let groupRequest = NSFetchRequest(entityName: "Todo")
        do{
            // Groups
            let groupResults = try managedContext.executeFetchRequest(groupRequest)
            
            let allTodos = groupResults as! [Todo]
            
            for todo in allTodos{
                print(todo.title)
                print(todo.archived)
                print("--------")
            }
            
        }catch let error as NSError{
            print("Error 'load' function (CoreData): \(error)")
        }
    }
    
    static func saveAll(){
        do{
            try managedContext.save()
            self.load()
        }catch let error as NSError{
            print("Error in 'save' function in Todo (CoreData): \(error)")
        }
    }
    
    /*
    func yest(id: String, title: String, archived: Bool, date: NSDate){
        self.id = id
        self.title = title
        self.archived = archived
        self.date = date
    }
    
    init(id: String, title: String, archived: Bool, date: NSDate, parent: Todo?, root: Todo?){
        self.id = id
        self.title = title
        self.archived = archived
        self.date = date
        self.parent = parent
        self.root = root
    }
    */
    
    func addChild(child: Todo){
        print("Do something about this!")
    //    self.children.append(child)
    }
    
    
}
