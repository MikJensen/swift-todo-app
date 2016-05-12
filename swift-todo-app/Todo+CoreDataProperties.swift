//
//  Todo+CoreDataProperties.swift
//  swift-todo-app
//
//  Created by Jógvan Olsen on 5/12/16.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Todo2 {

    @NSManaged var id: String?
    @NSManaged var title: String?
    @NSManaged var date: NSDate?
    @NSManaged var archived: NSNumber?
    @NSManaged var parent: Todo?
    @NSManaged var root: Todo?

}
