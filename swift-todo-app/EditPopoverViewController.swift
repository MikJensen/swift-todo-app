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
    @IBOutlet weak var markDoneButton: UIButton!
    @IBOutlet weak var achievedLabel: UILabel!
    
    let checked = UIImage(named: "checbox_unchecked")
    let unchecked = UIImage(named: "checkox_checked_green")
    
    var todoObj:Todo!
    
    var todoModel:TodoModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.text = "\(todoObj.title)"
        self.markDoneButton.setBackgroundImage(self.checked, forState: .Normal)
        updateAchieved()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func updateAchieved(){
        dispatch_async(dispatch_get_main_queue()){
            self.achievedLabel.text = ""
            if self.todoObj.archived == false{
                self.achievedLabel.text = "Ikke udført"
                self.markDoneButton.setBackgroundImage(self.unchecked, forState: .Normal)
            }else{
                self.achievedLabel.text = "Udført"
                self.markDoneButton.setBackgroundImage(self.checked, forState: .Normal)
            }
        }
    }
    @IBAction func segmentedAction(sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex{
        case 0:
            addButton.setTitle("Rediger", forState: .Normal)
            titleField.text = "\(todoObj.title)";
        case 1:
            addButton.setTitle("Tilføj ny", forState: .Normal)
            titleField.text = ""
        default:
            break; 
        }
    }
    @IBAction func addButtonAction(sender: UIButton) {
        if addButton.titleLabel!.text == "Rediger"{
            
        }else{
            todoModel.postNewTodo(titleField.text!, date: NSDate(), root: todoObj.root ?? todoObj, parent: todoObj){
                todo in
                if let todo = todo{
                    JLToast.makeText("Todo blev gemt", duration: JLToastDelay.ShortDelay).show()
                    self.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
                    self.todoObj.addChild(todo)
                     NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)
                }else{
                    JLToast.makeText("Todo blev ikke gemt, prøv igen!", duration: JLToastDelay.ShortDelay).show()
                }
            }
        }
    }
    @IBAction func achievedAction(sender: AnyObject) {
        todoObj.archived = !todoObj.archived
        var text = ""
        if todoObj.archived{
            text = "Todo er sat som udført!"
        }else{
            text = "Todo er sat som ikke udført!"
        }
        todoModel.updateTodo(todoObj){
            succes in
            if succes {
                JLToast.makeText(text, duration: JLToastDelay.ShortDelay).show()
                dispatch_async(dispatch_get_main_queue()){
                    self.updateAchieved()
                }
            }else{
                JLToast.makeText("Todo blev ikke opdateret, prøv igen!", duration: JLToastDelay.ShortDelay).show()
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
