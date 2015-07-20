//
//  FriendsTableViewController.swift
//
//
//  Created by Cem Eteke on 7/2/15.
//
//

import UIKit
import Alamofire

class FriendsTableViewController: UITableViewController {
    var friends: [Friend] = [Friend]()
    var sellectedChallengeID = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0);
        getFriends()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getFriends(){
        var fbRequest = FBSDKGraphRequest(graphPath:"/me/friends", parameters: nil);
        fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            
            if error == nil {
                
                if let friendsData = result.objectForKey("data") as? NSArray{
                    for i in 0 ..< friendsData.count
                    {
                        if let valueDict : NSDictionary = friendsData[i] as? NSDictionary{
                            if let id = valueDict.objectForKey("id") as? String{
                                println(id)
                                if let name = valueDict.objectForKey("name") as? String{
                                    self.friends.append(Friend(name: name, id: id, rank: 31))
                                }
                            }
                            
                        }
                    }
                }
                self.tableView.reloadData()
                
            } else {
                println("Error Getting Friends \(error.localizedDescription)");
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.friends.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("friend_cell", forIndexPath: indexPath) as! FriendsTableViewCell
        
        let friend = self.friends[indexPath.row]
        cell.friendName.text = friend.name
        cell.friendRank.text = "Rank: Loading..."
        
        cell.friendProfilePicture.layer.cornerRadius = cell.friendProfilePicture.frame.size.width / 2
        cell.friendProfilePicture.clipsToBounds = true
        
        Alamofire.request(.GET, "http://graph.facebook.com/\(friend.id)/picture?type=normal")
            .progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
                //hud.progress = (Float(totalBytesRead) / Float(totalBytesExpectedToRead))
            }
            .response() {
                (_, _, data, _) in
                if let imageData = data as? NSData{
                    cell.friendProfilePicture.image = UIImage(data: imageData)
                    //image.status = .Downloaded
                }
                //hud.hide(true)
        }
        
        Alamofire.request(.GET, Constants.getURL() + "getRank?id=\(friend.id)")
            .responseJSON { (_, _, JSON, _) in
                if let json = JSON as? NSDictionary{
                    if let rank = json.valueForKey("rank") as? Int{
                        cell.friendRank.text = "Rank: " + String(rank)
                    }else{
                        cell.friendRank.text = "Rank: Error"
                    }
                }else{
                    cell.friendRank.text = "Rank: Error"
                }
        }
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let friend = self.friends[indexPath.row]
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                println("Error: \(error.localizedDescription)")
            }
            else
            {
                let id = result.valueForKey("id") as! String
                Alamofire.request(.GET, Constants.getURL() + "challenge?challenged_id=\(friend.id)&challenger_id=\(id)")
                    .responseJSON { (_, _, JSON, _) in
                        if let json = JSON as? NSDictionary{
                            println(json)
                            if let status = json.valueForKey("status") as? String{
                                self.mm_drawerController.closeDrawerAnimated(true, completion: nil)
                                if let challenge_id = json.valueForKey("id") as? Int{
                                    self.sellectedChallengeID = challenge_id
                                    self.performSegueWithIdentifier("get_questions", sender: self)
                                }
                                println(status)
                            }else{
                                println("Error challenging")
                            }
                        }else{
                            println("Error challenging")
                        }
                }
            }
        })
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
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
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? UINavigationController{
            if let questionViewController = destination.viewControllers[0] as? QuestionViewController{
                questionViewController.challengeID = self.sellectedChallengeID
            }
        }

    }
    
    
}
