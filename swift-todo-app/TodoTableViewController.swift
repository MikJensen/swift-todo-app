//
//  TodoTableViewController.swift
//  swift-todo-app
//
//  Created by Mik Jensen on 09/05/2016.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit

class TodoTableViewController: UITableViewController {
    
    var todoArray = []
    var todoSelected: Int?
    
    @IBOutlet var todoTable: UITableView!
    var deleteTodoIndexPath: NSIndexPath? = nil
    
    var todos: [Todo] = [] {
        didSet{
            dispatch_async(dispatch_get_main_queue()){
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tabBar = self.tabBarController as! TabBarViewController
        
        if self.todos.count == 0{
            tabBar.todoModel.getTodos{
                todos in
                self.todos = todos
            }
        }
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "actionSelectedSegue"{
            let dest = segue.destinationViewController as! TodoTableViewController
            dest.todos = todos[self.todoSelected!].children
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
    
    func confirmDelete(todo: String)
    {
        let alert = UIAlertController(title: "Slet todo", message: "Er du sikker på at du vil slette todo \"\(todo)\" permanent?", preferredStyle: .ActionSheet)
        
        let DeleteAction = UIAlertAction(title: "Slet", style: .Destructive, handler: handleDeleteTodo)
        let CancelAction = UIAlertAction(title: "Annuller", style: .Cancel, handler: cancelDeleteTodo)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    func handleDeleteTodo(alertAction: UIAlertAction!) -> Void
    {
//        if let indexPath = deleteTodoIndexPath
//        {
//            todoTable.beginUpdates()
//            
//            TodoModel().DeleteTodo(self.todoArray[indexPath.row].GetTitle())
//            {
//                NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)
//            }
//            
//            todoTable.endUpdates()
//        }
    }
    
    func cancelDeleteTodo(alertAction: UIAlertAction!)
    {
        deleteTodoIndexPath = nil
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        cell.textLabel?.text = todos[indexPath.row].title
        if todos[indexPath.row].children.count == 0{
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    // TODO: Should be when the accessorytype is selected, instead of rowselect
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        self.todoSelected = indexPath.row
        performSegueWithIdentifier("actionSelectedSegue", sender: self)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
