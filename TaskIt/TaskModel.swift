//
//  TaskModel.swift
//  TaskIt
//
//  Created by Bashir on 2015-01-23.
//  Copyright (c) 2015 bashir. All rights reserved.
//

import Foundation
import CoreData

@objc(TaskModel)

class TaskModel: NSManagedObject {

    @NSManaged var completed: NSNumber
    @NSManaged var subtask: String
    @NSManaged var task: String
    @NSManaged var date: NSDate

}
