//
//  ViewController.swift
//  TaskIt
//
//  Created by Bashir on 2015-01-22.
//  Copyright (c) 2015 bashir. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, TaskDetailViewControllerDelegate, AddTaskViewControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
    
    var fetchedResultsController:NSFetchedResultsController = NSFetchedResultsController()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultsController = getFetchedResultsController()
        fetchedResultsController.delegate = self
        fetchedResultsController.performFetch(nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTaskDetail" {
            let detailVC: TaskDetailViewController = segue.destinationViewController as TaskDetailViewController
            let indexPath = self.tableView.indexPathForSelectedRow()
            let thisTask = fetchedResultsController.objectAtIndexPath(indexPath!) as TaskModel
            detailVC.detailTaskModel = thisTask
            detailVC.delegate = self
        }
        
        if segue.identifier == "showAddTask" {
            let addTaskVC: AddTaskViewController = segue.destinationViewController as AddTaskViewController
            addTaskVC.delegate = self
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: TaskCell = tableView.dequeueReusableCellWithIdentifier("myCell") as TaskCell
        
        let thisTask = fetchedResultsController.objectAtIndexPath(indexPath) as TaskModel
        
        cell.taskLabel.text = thisTask.task
        cell.descriptionLabel.text = thisTask.subtask
        cell.dateLabel.text = Date.toString(date: thisTask.date)
        cell.completedLabel.text = "\(thisTask.completed)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showTaskDetail", sender: self)
    }

    @IBAction func addButtonTapped(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("showAddTask", sender: self)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if fetchedResultsController.sections?.count == 1{
            let fetchedObjects = fetchedResultsController.fetchedObjects!
            
            //for statement - inside the for you need if contains statement...
            let testTask: TaskModel = fetchedObjects[0] as TaskModel
            if testTask.completed == true {
                return "Completed"
            }
            else {
                return "Todo"
            }
        }
        else {
            if section == 0 {
                return "Todo"
            }
            else {
                return "Completed"
            }
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let thisTask = fetchedResultsController.objectAtIndexPath(indexPath) as TaskModel
        if thisTask.completed == false {
            thisTask.completed = true

        } else {
            thisTask.completed = false

        }
        //tableView.reloadData()
        (UIApplication.sharedApplication().delegate as AppDelegate).saveContext()
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String! {
        if indexPath.section == 0 {
            return "Complete"
        } else {
            return "Unfinished"
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        var deleteButton = UITableViewRowAction(style: .Default, title: "Delete", handler: { (action, indexPath) in
            self.tableView.dataSource?.tableView?(
                self.tableView,
                commitEditingStyle: .Delete,
                forRowAtIndexPath: indexPath
            )
            
            return
        })
        
        if indexPath.section == 0 {
            deleteButton.title = "Complete"
        }
        
        if indexPath.section == 1 {
            deleteButton.title = "Incomplete"
        }
        deleteButton.backgroundColor = UIColor.lightGrayColor()
        
        return [deleteButton]
    }

    
    func taskFetchRequesst() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "TaskModel")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        let completedDescriptor = NSSortDescriptor(key: "completed", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor, completedDescriptor]
        return fetchRequest
    }
    
    func getFetchedResultsController() -> NSFetchedResultsController {
        fetchedResultsController = NSFetchedResultsController(fetchRequest: taskFetchRequesst(), managedObjectContext: managedObjectContext, sectionNameKeyPath: "completed", cacheName: nil)
        return fetchedResultsController
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
    
    func taskDetailEdited() {
        showAlert("Congradulations")
    }
    
    func showAlert(message: String) {
        var alert = UIAlertController(title: "Change Made!", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Ok!", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func addTask(message: String) {
        showAlert(message)
    }
    
    func addTaskCanceled(message: String) {
        showAlert(message)
    }
}

