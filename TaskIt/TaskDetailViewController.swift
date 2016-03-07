//  TaskDetailViewController.swift
//  TaskIt
//
//  Created by Bashir on 2015-01-22.
//  Copyright (c) 2015 bashir. All rights reserved.
//

import UIKit

@objc protocol TaskDetailViewControllerDelegate {
    optional func taskDetailEdited()
}

class TaskDetailViewController: UIViewController {
    
    
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var subTaskTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    var delegate: TaskDetailViewControllerDelegate?
    
    var detailTaskModel: TaskModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        println(self.detailTaskModel.task)
        self.taskTextField.text = self.detailTaskModel.task
        self.subTaskTextField.text = self.detailTaskModel.subtask
        self.dueDatePicker.date = self.detailTaskModel.date
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func doneBarButtonTapped(sender: UIBarButtonItem) {
        let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        detailTaskModel.task = taskTextField.text
        detailTaskModel.subtask = subTaskTextField.text
        detailTaskModel.date = dueDatePicker.date
        detailTaskModel.completed = detailTaskModel.completed
        
        appDelegate.saveContext()
        self.navigationController?.popViewControllerAnimated(true)
        delegate?.taskDetailEdited!()
    }
}
