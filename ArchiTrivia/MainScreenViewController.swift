//
//  MainScreenViewController.swift
//  
//
//  Created by Cem Eteke on 6/30/15.
//
//

import UIKit
import Alamofire

class MainScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var currentChallenges: [Challenge] = [Challenge]()
    var currentID: NSString = "No Id"
    var friends = [Friend]()
    var sellectedChallengeID = -1
    var isAlreadyLoaded = false
    var topContainer = UIView()
    var rankLabel = UILabel()
    @IBOutlet weak var tableView: UITableView!
    @IBAction func exit_action(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if(isAlreadyLoaded){
            self.getChallenges()
            self.getUserRank(rankLabel, topContainer: topContainer)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTopContainer()
        getFriends()
        var phoneImageBig = UIImage(named: "Contacts-25")
        var orientation = phoneImageBig?.imageOrientation
        var phoneImage = UIImage(CGImage: phoneImageBig?.CGImage, scale: 3.60, orientation: orientation!)
        var phoneButton: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        phoneButton.frame = CGRect(x: 0, y: 0, width: phoneImage!.size.width, height: phoneImage!.size.height)
        phoneButton.addTarget(self, action: "openList", forControlEvents: UIControlEvents.TouchUpInside)
        phoneButton.setBackgroundImage(phoneImage, forState: UIControlState.Normal)
        
        var phoneRightButton = UIBarButtonItem(customView: phoneButton)
        self.navigationItem.leftBarButtonItem = phoneRightButton
        
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let statusbarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let navigationBarHeight = self.navigationController?.navigationBar.frame.size.height
                
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openList(){
        self.mm_drawerController.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }
    
    func createTopContainer(){
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let statusbarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        let screenWidth = screenSize.width
        let navigationBarHeight = self.navigationController?.navigationBar.frame.size.height
        
        topContainer = UIView(frame:CGRect(x: 0, y: navigationBarHeight! + statusbarHeight, width: screenWidth, height: 75))
        self.view.addSubview(topContainer)
        topContainer.backgroundColor = UIColor.lightGrayColor()
        
        var nameLabel = UILabel()
        nameLabel.textColor = UIColor.whiteColor()
        
        rankLabel = UILabel()
        rankLabel.textColor = UIColor.whiteColor()
        
        var imageView = UIImageView(frame: CGRect(x: 25, y: 10, width: 55, height: 55))
        topContainer.addSubview(imageView)
        imageView.layer.cornerRadius = imageView.frame.size.height / 2
        imageView.clipsToBounds = true
        //MARK: Get Current User Info
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                println("Error: \(error.localizedDescription)")
            }
            else
            {

                let userName : NSString = result.valueForKey("name") as! NSString
                nameLabel.text = userName as String
                nameLabel.font = UIFont.boldSystemFontOfSize(16.0)
                nameLabel.sizeToFit()
                nameLabel.center = CGPoint(x: self.view.frame.size.width / 2, y: self.topContainer.frame.size.height / 2 - 10)
                self.topContainer.addSubview(nameLabel)
                println(result)
               
                let id: NSString = result.valueForKey("id") as! NSString
                NSUserDefaults.standardUserDefaults().setObject(id, forKey: "id")
                self.currentID = id
                //MARK: - Get Profile Picture
                Alamofire.request(.GET, "http://graph.facebook.com/\(id)/picture?type=normal")
                    .progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
                        //hud.progress = (Float(totalBytesRead) / Float(totalBytesExpectedToRead))
                    }
                    .response() {
                        (_, _, data, _) in
                        if let imageData = data as? NSData{
                            imageView.image = UIImage(data: imageData)
                            //image.status = .Downloaded
                        }
                        //hud.hide(true)
                }
                
                
                self.getUserRank(self.rankLabel, topContainer: self.topContainer)
                self.getChallenges()
                self.isAlreadyLoaded = true
            }
        })
    }
    
    func getUserRank(rankLabel: UILabel, topContainer: UIView){
        //MARK: - Get Current User Rank
        let id = NSUserDefaults.standardUserDefaults().objectForKey("id") as! String
        Alamofire.request(.GET, Constants.getURL() + "getRank?id=\(id)")
            .responseJSON { (_, _, JSON, _) in
                if let json = JSON as? NSDictionary{
                    if let rank = json.valueForKey("rank") as? Int{
                        rankLabel.text = "Your rank is \(rank)"
                        rankLabel.font = UIFont.systemFontOfSize(12.0)
                        rankLabel.sizeToFit()
                        rankLabel.center = CGPoint(x: self.view.frame.size.width / 2, y: topContainer.frame.size.height / 2 + 10)
                        topContainer.addSubview(rankLabel)
                    }else{
                        println("Error getting rank")
                    }
                }else{
                    println("Error getting rank")
                }
        }
    }
    
    //MARK: Get challenges
    func getChallenges(){
        currentChallenges = [Challenge]()
        let id = NSUserDefaults.standardUserDefaults().objectForKey("id") as! String
        Alamofire.request(.GET, Constants.getURL() + "getChallenges?id=\(id)")
            .responseJSON { (_, _, JSON, _) in
                if let json = JSON as? NSDictionary{
                    if let challenges = json.valueForKey("challenges") as? NSArray{
                        for c in challenges{
                            if let challenge = c as? NSDictionary{
                                let challenged_id = challenge.valueForKey("challenged_id") as! NSString
                                let challenger_id = challenge.valueForKey("challenger_id") as! NSString
                                let challenge_id = challenge.valueForKey("id") as! Int
                                let challenger_point = challenge.valueForKey("challenger_point") as! Int
                                let challenged_point = challenge.valueForKey("challenged_point") as! Int
                                self.currentChallenges.append(Challenge(challenged_id: challenged_id as String, challenger_id: challenger_id as String, id: challenge_id, challenger_point: challenger_point, challenged_point: challenged_point))
                            }
                        }
                        self.tableView.reloadData()
                    }
                }else{
                    println("Error getting challenges")
                }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("challenge_cell", forIndexPath: indexPath) as! ChallengeTableViewCell
        
        let challenge = currentChallenges[indexPath.row]
        
        cell.challenged_point.text = String(challenge.challenged_point)
        
        if (currentID == challenge.challenger_id){
            cell.challenger_name.text = "You"
        }else{
            for f in friends{
                if f.id == challenge.challenger_id{
                    cell.challenger_name.text = f.name
                    break
                }
            }
        }
        
        cell.challenger_point.text = String(challenge.challenger_point)
        
        if(currentID == challenge.challenged_id){
            cell.challenged_name.text = "You"
        }else{
            for f in friends{
                if f.id == challenge.challenged_id{
                    cell.challenged_name.text = f.name
                   break
                }
            }
        }
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentChallenges.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.sellectedChallengeID = currentChallenges[indexPath.row].id
        self.performSegueWithIdentifier("get_questions", sender: self)
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
