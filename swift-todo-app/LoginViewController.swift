//
//  LoginViewController.swift
//  swift-todo-app
//
//  Created by Mik Jensen on 09/05/2016.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var userModel = UserModel()
    
    var managedContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: 
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        Todo.managedContext = appDelegate?.managedObjectContext
        
        userModel.login("jeggy", password: "password", ch: {_,_ in
        
        let tm = TodoModel(userModel: self.userModel)
        tm.getTodos{
            todos in
            print(todos.count)
        }
        })
        //saveItem("asdf", title: "Bongo", date: NSDate(), archived: true)
        //load()
        /*
        if userModel.getUser() != nil{
            dispatch_async(dispatch_get_main_queue()){
                self.performSegueWithIdentifier("segueLogin", sender: self)
            }
        }
        
        errorMessageLabel.hidden = true
        setLoading(false)
 */
    }
    
    
    var todos: [Todo] = []
    func load(){
        let groupRequest = NSFetchRequest(entityName: "Todo")
        do{
            // Groups
            let groupResults = try managedContext.executeFetchRequest(groupRequest)
            
            let allTodos = groupResults as! [Todo]
            
            for todo in allTodos{
                print(todo.title)
                print(todo.archived)
                print("--------")
            }
            
        }catch let error as NSError{
            print("Error 'load' function (CoreData): \(error)")
        }
    }
    
    func saveItem(id:String, title: String, date: NSDate, archived: Bool){
        let todo = NSEntityDescription.insertNewObjectForEntityForName("Todo", inManagedObjectContext: managedContext) as! Todo
        todo.id = id
        todo.title = title
        todo.date = date
        todo.archived = archived
        
        
        //todo.belongsTo = self.currentSelectedGroup
            
        do{
            try managedContext.save()
            self.load()
        }catch let error as NSError{
            print("Error 'saveItem' function (CoreData): \(error)")
        }
    }
    
    
    // -----
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueLogin"{
            let destinationController = segue.destinationViewController as! TabBarViewController
            destinationController.userModel = self.userModel
        }
    }
    
    @IBAction func loginPressed(sender: UIButton) {
        setLoading(true)
        userModel.login(usernameField.text!, password: passwordField.text!){
            success, errorMessage in
            dispatch_async(dispatch_get_main_queue()){
                self.setLoading(false)
                if success{
                    self.performSegueWithIdentifier("segueLogin", sender: self)
                }else{
                    self.errorMessageLabel.hidden = false
                    self.errorMessageLabel.text = errorMessage
                }
            }
        }
    }
    
    @IBAction func registerPressed(sender: UIButton) {
        performSegueWithIdentifier("segueRegister", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setLoading(loading: Bool){
        dispatch_async(dispatch_get_main_queue()){
            if loading{
                self.errorMessageLabel.hidden = true
                self.loadingIndicator.hidden = false
                self.loadingIndicator.startAnimating()
            }else{
                self.loadingIndicator.hidden = true
                self.loadingIndicator.stopAnimating()
            }
        }
    }
}
