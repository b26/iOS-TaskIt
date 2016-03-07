//
//  AddTaskViewController.swift
//  TaskIt
//
//  Created by Bashir on 2015-01-23.
//  Copyright (c) 2015 bashir. All rights reserved.
//

import UIKit
import CoreData

protocol AddTaskViewControllerDelegate {
    func addTask(message: String)
    func addTaskCanceled(message: String)
}

class AddTaskViewController: UIViewController {
        
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var subtaskTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    var delegate:AddTaskViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func addTaskButtonTapped(sender: UIButton) {
        let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let managedObjectContext = appDelegate.managedObjectContext
        let entityDescription = NSEntityDescription.entityForName("TaskModel", inManagedObjectContext: managedObjectContext!)
        var task = TaskModel(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
        
        if NSUserDefaults.standardUserDefaults().boolForKey(kShouldCapitalizeTaskKey) == true {
            task.task = taskTextField.text.capitalizedString
        }
        
        else {
            task.task = taskTextField.text
        }
        
        if NSUserDefaults.standardUserDefaults().boolForKey(kShouldCompleteNewTodoKey) == true {
            task.completed = false
        }
        
        else {
            task.completed = true
        }
        
        task.date = dueDatePicker.date
        task.subtask = subtaskTextField.text
        
        appDelegate.saveContext()
        
        var request = NSFetchRequest(entityName: "TaskModel")
        var error:NSError? = nil
        
        var results:NSArray = managedObjectContext!.executeFetchRequest(request, error: &error)!
        
        for res in results {
            println(res)
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        delegate?.addTask("Task added")

    }
    
    @IBAction func cancelButtonTapped(sender: UIButton) {
        delegate?.addTaskCanceled("Task was not added")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
