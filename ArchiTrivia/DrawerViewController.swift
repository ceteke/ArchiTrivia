//
//  DrawerViewController.swift
//  
//
//  Created by Cem Eteke on 7/1/15.
//
//

import UIKit

class DrawerViewController: MMDrawerController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.openDrawerGestureModeMask = MMOpenDrawerGestureMode.All;
        self.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.All;
        self.maximumLeftDrawerWidth = 240
        self.showsShadow = false
        self.shouldStretchDrawer = false
        // Do any additional setup after loading the view.
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
