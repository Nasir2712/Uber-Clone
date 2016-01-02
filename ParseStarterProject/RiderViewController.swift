//
//  RiderViewController.swift
//  ParseStarterProject
//
//  Created by nasir on 1/1/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class RiderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        PFUser.logOut()
        
        let currentUser = PFUser.currentUser()
        
    }

}
