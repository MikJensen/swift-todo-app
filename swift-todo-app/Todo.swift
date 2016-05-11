//
//  Todo.swift
//  swift-todo-app
//
//  Created by Jógvan Olsen on 5/10/16.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit

class Todo: NSObject {
    
    var id: String
    var title: String
    var archived: Bool
    var date: NSDate
    var children: [Todo] = []
    
    var parent: Todo?
    var root: Todo?
    
    init(id: String, title: String, archived: Bool, date: NSDate){
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
    
    func addChild(child: Todo){
        self.children.append(child)
    }
    
    
    // TODO: I don't remember how the one liner get/set in swift was.
   
    
}
