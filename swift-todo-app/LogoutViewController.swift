//
//  LogoutViewController.swift
//  swift-todo-app
//
//  Created by Mik Jensen on 09/05/2016.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LogoutViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoutButton.roundCorners(.AllCorners, radius: 10)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutAction(sender: AnyObject) {
        self.confirmLogout()
    }
    // MARK: - Alert
    
    func confirmLogout(){
        let alert = UIAlertController(title: "Log ud", message: "Er du sikker på du vil logge ud?", preferredStyle: .ActionSheet)
        
        let LogoutAction = UIAlertAction(title: "Log ud", style: .Destructive, handler: handleLogout)
        let CancelAction = UIAlertAction(title: "Annuller", style: .Cancel, handler: cancelLogout)
        
        alert.addAction(LogoutAction)
        alert.addAction(CancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    func handleLogout(alertAction: UIAlertAction!) -> Void{
        KeychainWrapper.removeObjectForKey("user")
        
        // Todo: Only facebook logout if user used facebook.
        FBSDKLoginManager().logOut()
        
        
        self.tabBarController?.dismissViewControllerAnimated(true, completion: {})
    }
    
    func cancelLogout(alertAction: UIAlertAction!){
        
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return false
    }
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
