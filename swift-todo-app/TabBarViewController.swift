//
//  TabBarViewController.swift
//  swift-todo-app
//
//  Created by Jógvan Olsen on 5/10/16.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    /*
     Icons: 
        https://www.iconfinder.com/icons/984751/cogwheel_configuration_option_options_properties_setting_settings_icon#size=128
        https://www.iconfinder.com/icons/103174/list_menu_icon#size=128
        https://www.iconfinder.com/icons/763291/common_door_exit_logout_out_signout_icon#size=128
     
     We probably should use this script for fixing most git conflicts:
        http://stackoverflow.com/a/36716687/1832471
     
     */
    
    var userModel: UserModel!
    var todoModel: TodoModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.todoModel = TodoModel(userModel: userModel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
