//
//  SettingsViewController.swift
//  swift-todo-app
//
//  Created by Mik Jensen on 09/05/2016.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var tabBar: TabBarViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar = self.tabBarController as! TabBarViewController

    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Bruger info"
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        switch(indexPath.row){
            case 0:
                cell.textLabel?.text = "Brugernavn"
                cell.detailTextLabel!.text = tabBar.userModel.user?.username
            case 1:
                cell.textLabel?.text = "Fuldenavn"
                cell.detailTextLabel!.text = tabBar.userModel.user?.fullname
            case 2:
                cell.textLabel?.text = "År"
                cell.detailTextLabel!.text = "\(tabBar.userModel.user!.age)"
            default:()
        }

        return cell
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
