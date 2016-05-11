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
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.text = "First selected";
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func segmentedAction(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex{
        case 0:
            titleField.text = "First selected";
        case 1:
            titleField.text = "Second Segment selected";
        default:
            break; 
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
