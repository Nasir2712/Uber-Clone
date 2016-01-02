//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITextFieldDelegate {
    
    func displayAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
    }
    
    var signUpState = true
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var `switch`: UISwitch!
    @IBAction func signUp(sender: AnyObject) {
        
        if username.text == "" || Password.text == "" {
            
            displayAlert("Missing Field(s)", message: "Username and Password are required")
            
        }
        
        if (signUpState) {
        
            let user = PFUser()
            user.username = username.text
            user.password = Password.text
            user["isDriver"] = `switch`.on
            
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if let error = error {
                    let errorString = error.userInfo["error"] as? String
                    
                    self.displayAlert("SignUpFailed", message: errorString!)
                    
                    }
                 else {
                    
                    self.performSegueWithIdentifier("loginRider", sender: self)
                    
                }
            }
        } else {
            
            PFUser.logInWithUsernameInBackground(username.text!, password:Password.text!) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    
                    self.performSegueWithIdentifier("loginRider", sender: self)
                    
                } else {
                    
                    let errorString = error!.userInfo["error"] as? String
                    self.displayAlert("Log In Failed", message: errorString!)
                        
                    
                }
            }
        
        }
        
    }
    @IBOutlet weak var riderLabel: UILabel!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var driverLabel: UILabel!
    
    
    @IBAction func logIn(sender: AnyObject) {
        
        if (signUpState) {
            
            signUpButton.setTitle("LOGIN", forState: UIControlState.Normal)
            
            logInButton.setTitle("SIGNUP", forState: UIControlState.Normal)
            
            signUpState = false
            
            riderLabel.alpha = 0
            driverLabel.alpha = 0
            `switch`.alpha = 0
            
        } else {
            
            signUpButton.setTitle("SIGNUP", forState: UIControlState.Normal)
            
            logInButton.setTitle("LOGIN", forState: UIControlState.Normal)
            
            signUpState = true
            
            riderLabel.alpha = 1
            driverLabel.alpha = 1
            `switch`.alpha = 1
            
            
        }
        
        
    }
    @IBOutlet weak var logInButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        self.username.delegate = self
        self.Password.delegate = self
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        if PFUser.currentUser()?.username != nil {
            
            self.performSegueWithIdentifier("loginRider", sender: self)
        }
        
        
    }
    
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        self.view.endEditing(true)
        return false
    }
}

