//
//  EditPopoverViewController.swift
//  swift-todo-app
//
//  Created by Mik Jensen on 11/05/2016.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit

class EditPopoverViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var titleField: UITextField!
   
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var achievedLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    var todoObj:Todo?
    
    // var todoModel:TodoModel!
    
    var otherVC: TodoTableViewController!
    
    // TODO: Temporary fix
    var update = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton.roundCorners(.AllCorners, radius: 10)
        
        // If user did choose one row
        if let selectedIndex = otherVC.todoSelected{
            todoObj = otherVC.todos[selectedIndex]
            titleField.text = todoObj!.title
        } else {
            update = true
            segmentedControl.selectedSegmentIndex = 1
            segmentedControl.enabled = false
            titleField.placeholder = "Tilføj ny titel"
            addButton.setTitle("Tilføj ny", forState: .Normal)
            
            // If no row chosen, but array has parent.
            if otherVC.todos.count > 0 && otherVC.todos[0].parent != nil{
                todoObj = otherVC.todos[0].parent
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func segmentedAction(sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex{
        case 0:
            addButton.setTitle("Rediger", forState: .Normal)
            titleField.text = "\(todoObj!.title)";
        case 1:
            addButton.setTitle("Tilføj ny", forState: .Normal)
            titleField.text = ""
        default:
            break; 
        }
    }
    
    @IBAction func addButtonAction(sender: UIButton) {
        if addButton.titleLabel!.text == "Rediger"{
            if let todoObj = todoObj{
                todoObj.title = titleField.text!
                otherVC.todoModel.updateTodo(todoObj){
                    success in
                    if success{
                        dispatch_async(dispatch_get_main_queue()){
                            JLToast.makeText("Opdateret", duration: JLToastDelay.ShortDelay).show()
                            self.otherVC.tableView.reloadData()
                            self.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
                        }
                    } else {
                        JLToast.makeText("Blev ikke gemt, prøv igen senere!", duration: JLToastDelay.ShortDelay).show()
                    }
                }
            }
        }else{
            otherVC.todoModel.postNewTodo(titleField.text!, date: NSDate(), root: todoObj?.root ?? todoObj, parent: todoObj){
                todo in
                if let todo = todo{
                    JLToast.makeText("Todo blev gemt", duration: JLToastDelay.ShortDelay).show()
                    self.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
                    self.todoObj?.addChild(todo)
                    if self.update{
                        self.otherVC.todos.append(todo)
                    }
                    NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)
                }else{
                    JLToast.makeText("Todo blev ikke gemt, prøv igen senere!", duration: JLToastDelay.ShortDelay).show()
                }
            }
        }
    }

}
