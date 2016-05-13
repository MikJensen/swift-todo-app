//
//  TodoTableViewController.swift
//  swift-todo-app
//
//  Created by Mik Jensen on 09/05/2016.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit

class TodoTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    var todoSelected: Int?
    var achieved = 0
    var todoObj:Todo!
    
    //@IBOutlet var todoTable: UITableView!
    var deleteTodoIndexPath: NSIndexPath? = nil
    
    var todos: [Todo] = [] {
        didSet{
            dispatch_async(dispatch_get_main_queue()){
                self.tableView.reloadData()
            }
        }
    }
    var tabBar:TabBarViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar = self.tabBarController as! TabBarViewController

        if self.todos.count == 0{
            tabBar.todoModel.getTodos{
                todos in
                self.todos = todos
            }
        } else {
            self.navigationItem.title = todos[0].parent?.title
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.reloadTodos(_:)),name:"reload", object: nil)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    func reloadTodos(notification: NSNotification){
        dispatch_async(dispatch_get_main_queue()){
            self.tableView.reloadData()
        }
    }
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "actionSelectedSegue"{
            let dest = segue.destinationViewController as! TodoTableViewController
            dest.todos = todos[self.todoSelected!].children
        }
        if segue.identifier == "seguePopover"{
            let editTodo = segue.destinationViewController as? EditPopoverViewController
            editTodo?.otherVC = self
            if todoObj != nil{
                editTodo?.todoObj = todoObj
            }
            
            let vc = segue.destinationViewController
            editTodo?.todoModel = (self.tabBarController as! TabBarViewController).todoModel
            
            let controller = vc.popoverPresentationController
            
            if controller != nil
            {
                controller?.delegate = self
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    /*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }*/
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todos.count
    }
    
    // MARK: - Alert
    
    func confirmDelete(todo: String){
        let alert = UIAlertController(title: "Slet todo", message: "Er du sikker på at du vil slette todo \"\(todo)\" permanent?", preferredStyle: .ActionSheet)
        
        let DeleteAction = UIAlertAction(title: "Slet", style: .Destructive, handler: handleDeleteTodo)
        let CancelAction = UIAlertAction(title: "Annuller", style: .Cancel, handler: cancelDeleteTodo)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func handleDeleteTodo(alertAction: UIAlertAction!) -> Void{
        if let indexPath = todoSelected
        {
            tableView.beginUpdates()
            tabBar.todoModel.removeTodo(todos[indexPath]){
                succes in
                if succes{
                    NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)
                }else{
                    
                }
                dispatch_async(dispatch_get_main_queue()){
                    self.tableView.endUpdates()
                }
            }
        }
    }
    
    func cancelDeleteTodo(alertAction: UIAlertAction!){
        deleteTodoIndexPath = nil
    }
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell
        
        cell.todoLabel.text = todos[indexPath.row].title
        if todos[indexPath.row].children.count == 0{
            cell.accessoryType = .None
        }
        
        if todos[indexPath.row].archived != true{
            cell.achievedImage.image = UIImage(named: "checkbox_unchecked")
        }else{
            cell.achievedImage.image = UIImage(named: "checkbox_checked_green")
        }
        
        return cell
    }
    
    // TODO: Should be when the accessorytype is selected, instead of rowselect
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.todoSelected = indexPath.row
        if todos[indexPath.row].children.count != 0{
            performSegueWithIdentifier("actionSelectedSegue", sender: self)
        }
        
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
        let delete = UITableViewRowAction(style: .Destructive, title: "Slet"){
            action, btnIndexPath in
            self.todoSelected = indexPath.row
            let todo = self.todos[indexPath.row].title
            self.confirmDelete(todo)
        }
        let add = UITableViewRowAction(style: .Normal, title: "Rediger"){
            action, btnIndexPath in
            self.todoSelected = indexPath.row
            self.todoObj = self.todos[self.todoSelected!]
            self.performSegueWithIdentifier("seguePopover", sender: self)
        }
        
        return [delete, add]
    }
    @IBAction func barButtonAction(sender: AnyObject) {
        todoObj = nil
        performSegueWithIdentifier("seguePopover", sender: self)
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle{
        return .None
    }

}
