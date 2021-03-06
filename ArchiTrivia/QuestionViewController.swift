//
//  QuestionViewController.swift
//  ArchiTrivia
//
//  Created by Cem Eteke on 7/17/15.
//  Copyright (c) 2015 Cem Eteke. All rights reserved.
//

import UIKit
import Alamofire

class QuestionViewController: UIViewController {
    
    @IBOutlet weak var ans_1: UIButton!
    @IBOutlet weak var ans_2: UIButton!
    @IBOutlet weak var ans_3: UIButton!
    @IBOutlet weak var ans_4: UIButton!
    @IBOutlet weak var questionText: UITextView!
    @IBOutlet weak var questionImageView: UIImageView!
    var challengeID = -1
    var correctAnswer: String = ""
    var correctCount: Int = 0
    let alertView = SweetAlert()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpQuestion()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpQuestion(){
        ans_1.enabled = false
        ans_2.enabled = false
        ans_3.enabled = false
        ans_4.enabled = false
        self.questionImageView.hidden = true
        self.questionImageView.image = nil
        let q_hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        q_hud.labelText = "Getting Question"
        Alamofire.request(.GET, Constants.getURL() + "getRandomQuestion")
            .responseJSON { (_, _, JSON, _) in
                if let json = JSON as? NSDictionary{
                    println(json)
                    if let correctAnswer = json.valueForKey("correct_answer") as? String{
                        self.correctAnswer = correctAnswer
                        if let ans1 = json.valueForKey("ans_1") as? String{
                            if let ans2 = json.valueForKey("ans_2") as? String{
                                if let ans3 = json.valueForKey("ans_3") as? String{
                                    var answers: NSMutableArray = NSMutableArray()
                                    answers.addObject(ans1)
                                    answers.addObject(ans2)
                                    answers.addObject(ans3)
                                    answers.addObject(correctAnswer)
                                    self.putRandomAnswer(answers)
                                    if let questionTitle = json.valueForKey("name") as? String{
                                        self.questionText.text = questionTitle
                                        self.questionText.sizeToFit()
                                    }
                                    self.ans_1.enabled = true
                                    self.ans_2.enabled = true
                                    self.ans_3.enabled = true
                                    self.ans_4.enabled = true
                                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                                    if let imageURL = json.valueForKey("image_url") as? String{
                                        if imageURL != "None"{
                                            self.questionImageView.hidden = false
                                            let hud = MBProgressHUD.showHUDAddedTo(self.questionImageView, animated: true)
                                            hud.mode = MBProgressHUDMode.AnnularDeterminate
                                            Alamofire.request(.GET, imageURL)
                                                .progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
                                                    hud.progress = (Float(totalBytesRead) / Float(totalBytesExpectedToRead))
                                                }
                                                .response() {
                                                    (_, _, data, _) in
                                                    if let imageData = data as? NSData{
                                                        self.questionImageView.image = UIImage(data: imageData)
                                                        
                                                    }
                                                    hud.hide(true)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }else{
                    println("Error getting question")
                }
        }
    }
    
    func putRandomAnswer(answers: NSMutableArray){
        var rand: Int = Int(arc4random_uniform(4))
        self.ans_1.setTitle(answers[rand] as? String, forState: .Normal)
        answers.removeObjectAtIndex(rand)
        rand = Int(arc4random_uniform(3))
        self.ans_2.setTitle(answers[rand] as? String, forState: .Normal)
        answers.removeObjectAtIndex(rand)
        rand = Int(arc4random_uniform(2))
        self.ans_3.setTitle(answers[rand] as? String, forState: .Normal)
        answers.removeObjectAtIndex(rand)
        rand = Int(arc4random_uniform(1))
        self.ans_4.setTitle(answers[rand] as? String, forState: .Normal)
        answers.removeObjectAtIndex(rand)
    }
    
    @IBAction func ans_1_action(sender: AnyObject) {
        let ans_1_text = self.ans_1.titleLabel?.text
        if ans_1_text == self.correctAnswer{
            
            answeredCorrect()
        }else{
            answeredWrong()
        }
    }
    
    
    @IBAction func ans_2_action(sender: AnyObject) {
        let ans_2_text = self.ans_2.titleLabel?.text
        if ans_2_text == self.correctAnswer{
            answeredCorrect()
        }else{
            answeredWrong()
            
        }
    }
    
    @IBAction func ans_3_action(sender: AnyObject) {
        let ans_3_text = self.ans_3.titleLabel?.text
        if ans_3_text == self.correctAnswer{
            answeredCorrect()
        }else{
            answeredWrong()
            
        }
    }
    
    @IBAction func ans_4_action(sender: AnyObject) {
        let ans_4_text = self.ans_4.titleLabel?.text
        if ans_4_text == self.correctAnswer{
            answeredCorrect()
        }else{
            answeredWrong()
            
        }
    }
    
    func answeredWrong(){
        alertView.showAlert("Wrong!", subTitle: "Sorry, answer was " + self.correctAnswer, style: AlertStyle.Error, buttonTitle: "Continue", action: {(isOtherButton) -> Void in
            let playerID: String = NSUserDefaults.standardUserDefaults().objectForKey("id") as! String
            Alamofire.request(.GET, Constants.getURL() + "completeAnswering?player_id="+playerID+"&points_gained="+String(self.correctCount)+"&challenge_id="+String(self.challengeID))
                .responseJSON { (_, _, JSON, _) in
                    if let json = JSON as? NSDictionary{
                        println(json)
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }else{
                        println("Error challenge saving proccess")
                    }
            }
        })
    }
    
    func answeredCorrect(){
        alertView.showAlert("Correct!", subTitle: "Click to continue", style: AlertStyle.Success, buttonTitle: "Continue", action: {(isOtherButton) -> Void in
            self.setUpQuestion()
            println("Correct")
            self.correctCount++
            }
        )
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
