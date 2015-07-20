//
//  ViewController.swift
//  ArchiTrivia
//
//  Created by Cem Eteke on 6/30/15.
//  Copyright (c) 2015 Cem Eteke. All rights reserved.
//

import UIKit
import Alamofire
class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidAppear(animated: Bool) {
        let loginView : FBSDKLoginButton = FBSDKLoginButton()
        self.view.addSubview(loginView)
        loginView.center = self.view.center
        loginView.readPermissions = ["public_profile", "email", "user_friends"]
        loginView.delegate = self
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            if let mainScreen = mainStoryboard.instantiateViewControllerWithIdentifier("drawer") as? DrawerViewController{
                self.presentViewController(mainScreen, animated: true, completion: nil)
            }else{
                println("Error showing main screen")
            }
            // User is already logged in, do work such as go to next view controller.
        }
        else
        {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        println("User Logged In")
        
        
        if ((error) != nil)
        {
            println(error.localizedDescription)
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            
            if let mainScreen = mainStoryboard.instantiateViewControllerWithIdentifier("drawer") as? DrawerViewController{
                let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
                graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                    if ((error) != nil)
                    {
                        println("Error: \(error.localizedDescription)")
                    }else{
                        let name : NSString = result.valueForKey("name") as! NSString
                        let id: NSString = result.valueForKey("id") as! NSString
                        let uri = "id=\(id as String)&name=\(name as String)"
                        let endocededURi = uri.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
                        let url = Constants.getURL() + "createUser?" + endocededURi!
                        Alamofire.request(.GET, url)
                            .responseJSON { (_, _, JSON, _) in
                                if let json = JSON as? NSDictionary{
                                   self.presentViewController(mainScreen, animated: true, completion: nil)
                                }else{
                                    println("Error creating user")
                                }
                        }
                        
                    }
                })
            }else{
                println("Error showing main screen")
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User Logged Out")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

