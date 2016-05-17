//
//  TodoTableViewController.swift
//  swift-todo-app
//
//  Created by Mik Jensen on 09/05/2016.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit

class TodoTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    let imgChecked = UIImage(named: "checkbox_checked_green")
    let imgUnchecked = UIImage(named: "checkbox_unchecked")

    var todoModel: TodoModel!
    var tabBar:TabBarViewController!
    var deleteTodoIndexPath: NSIndexPath? = nil
    var todoSelected: Int?
    
    var todos: [Todo] = [] {
        didSet{ // reloadData when recieving an update to todos array
            dispatch_async(dispatch_get_main_queue()){
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tabBar = self.tabBarController as! TabBarViewController
        todoModel = tabBar.todoModel
        
        // if todos is empty, load all from the API
        if self.todos.count == 0{
            loadFromApi()
            
            // Enable refresh only for root, as API doesn't support fetching from a specified ID
            self.refreshControl = UIRefreshControl()
            self.refreshControl!.addTarget(self, action: #selector(TodoTableViewController.loadFromApi(_:)), forControlEvents: UIControlEvents.ValueChanged)
        } else {
            self.navigationItem.title = todos[0].parent?.title
        }
        
        
        // Listen for the "reload" notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.reloadTodos(_:)),name:"reload", object: nil)
    }
    
    func loadFromApi(sender:AnyObject? = nil){
        dispatch_async(dispatch_get_main_queue()){
            self.refreshControl!.beginRefreshing()
        }
        tabBar.todoModel.getTodos{
            todos in
            self.todos = todos
            dispatch_async(dispatch_get_main_queue()){
                self.refreshControl!.endRefreshing()
            }
        }
    }
    
    // When 'reload' Notification comes
    func reloadTodos(notification: NSNotification){
        dispatch_async(dispatch_get_main_queue()){
            self.tableView.reloadData()
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
            case "actionSelectedSegue":
                let dest = segue.destinationViewController as! TodoTableViewController
                dest.todos = todos[self.todoSelected!].children
                break
            case "seguePopover":
                let editTodo = segue.destinationViewController as? EditPopoverViewController
                editTodo?.otherVC = self
                if let controller = editTodo?.popoverPresentationController{
                    controller.delegate = self
                }
                break
            default: ()
        }
    }
    
    // TableView Stuff:

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todos.count
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell
        
        cell.todoLabel.text = todos[indexPath.row].title
        if todos[indexPath.row].children.count == 0{
            cell.accessoryType = .None
        } else {
            cell.accessoryType = .DisclosureIndicator
        }
        
        if todos[indexPath.row].archived != true{
            cell.achievedImage.image = imgUnchecked
        }else{
            cell.achievedImage.image = imgChecked
        }
        cell.achievedImage.userInteractionEnabled = true
        let gest = UITapGestureRecognizer(target:self, action:#selector(TodoTableViewController.imageTapped(_:)))
        cell.achievedImage.addGestureRecognizer(gest)
        
        return cell
    }
    
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
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?{
        let delete = UITableViewRowAction(style: .Destructive, title: "Slet"){
            action, btnIndexPath in
            self.todoSelected = indexPath.row
            let todo = self.todos[indexPath.row].title
            self.confirmDelete(todo)
        }
        let add = UITableViewRowAction(style: .Normal, title: "Rediger"){
            action, btnIndexPath in
            self.todoSelected = indexPath.row
            self.performSegueWithIdentifier("seguePopover", sender: self)
        }
        
        return [delete, add]
    }
    
    
    // When delete is pressed
    func confirmDelete(todo: String){
        let alert = UIAlertController(title: "Slet \"\(todo)\" todo", message: "Er du sikker på at du vil slette todo \"\(todo)\" permanent?\nDen Vil også slette todos under den her todo!", preferredStyle: .ActionSheet)
        
        let DeleteAction = UIAlertAction(title: "Slet", style: .Destructive, handler: handleDeleteTodo)
        let CancelAction = UIAlertAction(title: "Annuller", style: .Cancel, handler: cancelDeleteTodo)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // Delete accepted by user
    func handleDeleteTodo(alertAction: UIAlertAction!) -> Void{
        if let indexPath = todoSelected
        {
            tabBar.todoModel.removeTodo(todos[indexPath]){
                succes in
                if succes{
                    print(indexPath)
                    print(self.todos.count)
                        self.todos.removeAtIndex(indexPath)
                }else{
                    
                }
            }
        }
    }
    
    // Delete rejected by user
    func cancelDeleteTodo(alertAction: UIAlertAction!){
        deleteTodoIndexPath = nil
    }
    
    // Achive Image tapped
    func imageTapped(sender: UITapGestureRecognizer){
        let tapLocation = sender.locationInView(self.tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(tapLocation)
        
        let selected = todos[indexPath!.row]
        selected.archived = !selected.archived
        
        let row = self.tableView.cellForRowAtIndexPath(indexPath!) as! TableViewCell
        row.achievedImage.image = (selected.archived) ? imgChecked : imgUnchecked

        todoModel.updateTodo(selected){
            succes in
            
            if !succes {
                dispatch_async(dispatch_get_main_queue()){
                    row.achievedImage.image = (!selected.archived) ? self.imgChecked : self.imgUnchecked
                }
                JLToast.makeText("Blev ikke opdateret, prøv venligst igen!", duration: JLToastDelay.ShortDelay).show()
            }
        }
    }
    
    // Plus icon pressed
    @IBAction func barButtonAction(sender: AnyObject) {
        self.todoSelected = nil
        performSegueWithIdentifier("seguePopover", sender: self)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle{
        return .None
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
