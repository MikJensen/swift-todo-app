//
//  Todo.swift
//  swift-todo-app
//
//  Created by Jógvan Olsen on 5/10/16.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit

class Todo: NSObject {
    
    var title: String
    var parent: Todo?
    var root: Todo?
    var archived: Bool
    var date: NSDate
    var children: [Todo]
    
    init(title: String, parent: Todo?, root: Todo?, archived: Bool, date: NSDate, children: [Todo]){
        self.title = title
        self.parent = parent
        self.root = root
        self.archived = archived
        self.date = date
        self.children = children
    }
    
    func addChild(child: Todo){
        self.children.append(child)
    }

}
