//
//  PromotionViewController.swift
//  SPADS-RestaurantBeacon
//
//  Created by BBaoBao on 8/5/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class PromotionViewController: UIViewController {
    
    var promotionsFileArray: NSArray = NSArray()
    var quizzesArray:NSArray = NSArray()
    var quizDic:[String] = [String]()
    var noticeLabel:UILabel = UILabel()
    var imageView:UIImageView = UIImageView()
    var promotionLabel:UILabel = UILabel()
    var beacons : AnyObject = []

    override func viewDidLoad() {
        super.viewDidLoad()

        //Get beacons
        print(beacons)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateView:", name: "updateBeaconTableView", object: nil)
        queryParseMethod()
        self.view.backgroundColor = UIColor.MKColor.Blue
        noticeLabel.frame = CGRectMake(0, 0, self.view.frame.width, 200)
        noticeLabel.text = "Please go to nearby our restaurants to receive promotion information"
        noticeLabel.textColor = UIColor.whiteColor()
        noticeLabel.font = UIFont(name: "Helvetica Neue-Light", size: 20)
        noticeLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        noticeLabel.numberOfLines = 0
        noticeLabel.textAlignment = .Center
        noticeLabel.center = self.view.center
        self.view.addSubview(noticeLabel)
        // Do any additional setup after loading the view.
        
        imageView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        imageView.image = UIImage(named: "PromotionImage.png")
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.view.addSubview(imageView)
        self.view.bringSubviewToFront(imageView)
        imageView.hidden = true
        promotionLabel.frame = CGRectMake(0, 0, self.view.frame.width, 200)
        //Estimote
        estimoteFunction()
    }
    
    func showAlertForQuiz() {
        let alertVC:NYAlertViewController = NYAlertViewController(nibName: nil, bundle: nil)
        alertVC.backgroundTapDismissalGestureEnabled = false
        alertVC.swipeDismissalGestureEnabled = true
        alertVC.title = "Quiz(zes) for Promotion"
        alertVC.message = "Welcome, do you agree to take a few quizzes for promotion today? If you're right, you can take a big promotion from our shop. Don't worry, you also have a smaller promotion if you get wrong answer"
        alertVC.buttonCornerRadius = 20.0
        alertVC.view.tintColor = self.view.tintColor
        alertVC.titleFont = UIFont(name: "AvenirNext-Bold", size: 18.0)
        alertVC.messageFont = UIFont(name: "AvenirNext-Medium", size: 16.0)
        alertVC.buttonTitleFont = UIFont(name: "AvenirNext-Regular", size: alertVC.buttonTitleFont.pointSize)
        alertVC.cancelButtonTitleFont = UIFont(name: "AvenirNext-Medium", size: alertVC.cancelButtonTitleFont.pointSize)
        alertVC.alertViewBackgroundColor = UIColor(white: 0.19, alpha: 1.0)
        alertVC.alertViewCornerRadius = 10.0
        alertVC.titleColor = UIColor.MKColor.Orange
        alertVC.messageColor = UIColor.whiteColor()
        alertVC.buttonColor = UIColor.MKColor.Green
        alertVC.buttonTitleColor = UIColor(white: 0.19, alpha: 1.0)
        alertVC.cancelButtonColor = UIColor.MKColor.Red
        alertVC.cancelButtonTitleColor = UIColor(white: 0.19, alpha: 1.0)
        alertVC.addAction(NYAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            //OK action
            self.dismissViewControllerAnimated(true, completion: nil)
            self.showQuizQuestion()
        }))
        alertVC.addAction(NYAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
            //Cancel action
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alertVC, animated: true, completion: nil)
    }
    
    func showQuizQuestion() {
        print(quizDic)
        //TODO: make random function to get random question
        let randomIndex = arc4random_uniform(UInt32(self.quizzesArray.count))
        print(randomIndex)
        self.quizDic.removeAll(keepCapacity: false)
        let quizObject:PFObject = quizzesArray.objectAtIndex(Int(randomIndex)) as! PFObject
        if let quizQuestion = quizObject["QuizQuestion"] as? String {
            quizDic.append(quizQuestion)
        }
        if let quizOption1 = quizObject["Option1"] as? String {
            quizDic.append(quizOption1)
        }
        if let quizOption2 = quizObject["Option2"] as? String {
            quizDic.append(quizOption2)
        }
        if let quizOption3 = quizObject["Option3"] as? String {
            quizDic.append(quizOption3)
        }
        if let quizOption4 = quizObject["Option4"] as? String {
            quizDic.append(quizOption4)
        }
        if let quizAnswer = quizObject["Answer"] as? String {
            quizDic.append(quizAnswer)
        }

        
        //Show Quiz Question
        let alertQuizVC:NYAlertViewController = NYAlertViewController(nibName: nil, bundle: nil)
        alertQuizVC.title = "Quiz"
        alertQuizVC.message = quizDic[0]
        
        alertQuizVC.view.tintColor = self.view.tintColor
        alertQuizVC.titleFont = UIFont(name: "", size: alertQuizVC.titleFont.pointSize)
        alertQuizVC.messageFont = UIFont(name: "", size: alertQuizVC.messageFont.pointSize)
        alertQuizVC.buttonTitleFont = UIFont(name: "", size: alertQuizVC.buttonTitleFont.pointSize)
        alertQuizVC.cancelButtonTitleFont = UIFont(name: "", size: alertQuizVC.cancelButtonTitleFont.pointSize)
        
        for var i = 1; i < quizDic.count-1; i++ {
            let actionTitle = quizDic[i]
            let actionStyle = UIAlertActionStyle.Default
            
            alertQuizVC.addAction(NYAlertAction(title: actionTitle, style: actionStyle, handler: { (action) -> Void in
                //Do something here
                if let index = self.quizDic.indexOf(actionTitle) {
                    print("Option \(index) is picked")
                    let answerNumber = Int((self.quizDic.last)!)
                    if index == answerNumber {
                        print("Right")
                        self.pushQuizRightAnswerNotification()
                        // Check that user got big promotion - no more push quiz
                        let defaults = NSUserDefaults.standardUserDefaults()
                        defaults.setObject(self.getDayMonthYear(), forKey: "isGetBigPromotion")
                    } else {
                        print("Wrong")
                        self.pushQuizWrongAnswerNotification()
                        let defaults = NSUserDefaults.standardUserDefaults()
                        if let isHaveChance = defaults.stringForKey("isHaveChance"){
                            if isHaveChance == "true" {
                                //User got wrong answer for first tiem - make another chance
                                let defaults = NSUserDefaults.standardUserDefaults()
                                defaults.setObject("false", forKey: "isHaveChance")
                            } else {
                                // Check that user got big promotion - no more push quiz
                                let defaults = NSUserDefaults.standardUserDefaults()
                                defaults.setObject(self.getDayMonthYear(), forKey: "isGetBigPromotion")
                            }
                        } else {
                            //First time got wrong answer
                            let defaults = NSUserDefaults.standardUserDefaults()
                            defaults.setObject("true", forKey: "isHaveChance")
                        }
                        
                    }
                } else {
                    print("Can't find any options")
                }
            }))
        }
        
        //Add cancel action
        alertQuizVC.addAction(NYAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
            self.quizDic.removeAll(keepCapacity: false)
        }))
        
        self.presentViewController(alertQuizVC, animated: true, completion: nil)
        
    }
    
    func updateView(note: NSNotification!){
        beacons = note.object!
        if beacons.count != 0 {
            if promotionsFileArray.count != 0 {
                queryParseQuizMethod()
                let defaults = NSUserDefaults.standardUserDefaults()
                if let isGetPromotion = defaults.stringForKey("isGetBigPromotion") {
                    if isGetPromotion == self.getDayMonthYear() {
                        //User got the big promotion for right answer
                        //Do nothing
                    } else {
                        //User didn't get the big promotion for right answer
                        if let isHaveChance = defaults.stringForKey("isHaveChance") {
                            if isHaveChance == "true" {
                                showAlertForQuiz()
                            } else {
                                //Do nothing
                            }
                        } else {
                            // First time
                            showAlertForQuiz()
                        }
                    }
                } else {
                    // First time run app
                    showAlertForQuiz()
                }
            }
        } else {
            imageView.hidden = true
            promotionLabel.hidden = true
            noticeLabel.hidden = false
        }
    }
    
    func doDisplayPromotion(promotionObject:PFObject){
        //var promotionObject:PFObject = promotionsFileArray.objectAtIndex(promotionsFileArray.count-1) as! PFObject
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute, .Day, .Month, .Year], fromDate: date)
        let hour = String(components.hour)
        
        //Check start time and end time of promotion
        if let startTime = promotionObject["StartTime"] as? Int {
            //If having start time
            if let endTime = promotionObject["EndTime"] as? Int {
                //If having end time
                //Current hour is between start and end time
                if startTime < Int(hour) && endTime > Int(hour) {
                    getParseObject(promotionObject)
                }
            }
            else {
                //If no having end time
                //If current time is higher than start time
                if startTime < Int(hour) {
                    getParseObject(promotionObject)
                }
            }
        } else { //If no having start and end time
            getParseObject(promotionObject)
        }
    }

    
    func getParseObject(promotionObject: PFObject) {
        imageView.hidden = false
        promotionLabel.hidden = false
        noticeLabel.hidden = true
        let imageFile:PFFile = promotionObject["PromotionImage"] as! PFFile
        imageFile.getDataInBackgroundWithBlock({(data, error) in
            if error == nil {
                self.imageView.image = UIImage(data: data!)
                self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
                self.view.addSubview(self.imageView)
                self.view.bringSubviewToFront(self.imageView)
            }
        })
        //promotionLabel.text = "今、わが店はこんの産品を１０%割り引くいたします。 \nいただきます！"
        promotionLabel.text = promotionObject["PromotionDescription"] as? String
        promotionLabel.textColor = UIColor.whiteColor()
        promotionLabel.font = UIFont(name: "Helvetica Neue-Light", size: 50)
        promotionLabel.numberOfLines = 0
        promotionLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(promotionLabel)
        self.view.bringSubviewToFront(promotionLabel)
    }
    
    func estimoteFunction() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Define the query that will provide the data for the table view
    func queryParseMethod() {
        //println("Start query")
        let query = PFQuery(className: "Promotion")
        query.orderByAscending("PromotionID")
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) promotions.")
                self.promotionsFileArray = objects!
                //println(self.promotionsFileArray)
            }
        }
    }
    
    func queryParseQuizMethod() {
        let queryQuiz = PFQuery(className: "Quizzes")
        queryQuiz.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                //The finding succeeded
                print("Successfully retrieved \(objects!.count) quizzes.")
                self.quizzesArray = objects!
            }
        }
    }
    
    @IBAction func showAlert(sender: AnyObject) {
        //Custom Alert View
        showAlertForQuiz()
    }
    
    func getDayMonthYear() -> String {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute, .Day, .Month, .Year], fromDate: date)
        let hour = String(components.hour)
        let minutes = String(components.minute)
        let day = String(components.day)
        let month = String(components.month)
        let year = String(components.year)
        
        let daymonthyear = "\(day)-\(month)-\(year)"
        _ = "\(hour):\(minutes)"
        
        return daymonthyear
    }
    
    func pushQuizRightAnswerNotification() {
        self.quizDic.removeAll(keepCapacity: false)
        self.dismissViewControllerAnimated(true, completion: nil)
        let successAlertViewController:NYAlertViewController = NYAlertViewController()
        successAlertViewController.addAction(NYAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: {
                for index in 0...self.promotionsFileArray.count-1 {
                    let promotionObject:PFObject = self.promotionsFileArray.objectAtIndex(index) as! PFObject
                    if let priority = promotionObject["Priority"] as? String {
                        if priority == String(1) {
                            self.doDisplayPromotion(promotionObject)
                        }
                    }
                }
            })
        }))
        successAlertViewController.title = "Congratulation"
        successAlertViewController.message = "Your answer is right. You'll get bigger promotion for today. Touch 'Ok' to see it now !"
        successAlertViewController.titleColor = UIColor.MKColor.Orange
        successAlertViewController.buttonColor = UIColor.MKColor.Green
        successAlertViewController.buttonTitleColor = UIColor(white: 0.19, alpha: 1.0)
        self.presentViewController(successAlertViewController, animated: true, completion: nil)
    }
    
    func pushQuizWrongAnswerNotification() {
        self.quizDic.removeAll(keepCapacity: false)
        self.dismissViewControllerAnimated(true, completion: nil)
        let successAlertViewController:NYAlertViewController = NYAlertViewController()
        successAlertViewController.addAction(NYAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: {
                for index in 0...self.promotionsFileArray.count-1 {
                    let promotionObject:PFObject = self.promotionsFileArray.objectAtIndex(index) as! PFObject
                    if let priority = promotionObject["Priority"] as? String {
                        if priority == String(2) {
                            self.doDisplayPromotion(promotionObject)
                        }
                    }
                }
            })
        }))
        successAlertViewController.title = "Ops"
        successAlertViewController.message = "Your answer is wrong. Don't worry, you'll also get promotion today. Good luck next time. Touch 'Ok' to see it now!"
        successAlertViewController.titleColor = UIColor.MKColor.Orange
        successAlertViewController.buttonColor = UIColor.MKColor.Green
        successAlertViewController.buttonTitleColor = UIColor(white: 0.19, alpha: 1.0)
        self.presentViewController(successAlertViewController, animated: true, completion: nil)
    }
}
