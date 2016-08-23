//
//  AddQuizViewController.swift
//  SPADS-RestaurantBeacon
//
//  Created by BBaoBao on 8/17/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class AddQuizViewController: UIViewController, UITextFieldDelegate {

    var backButton: MKButton = MKButton()
    var scrollView: UIScrollView!
    var lbMainText: String = String()
    var commitButton: MKButton = MKButton()
    var isCheckedForCommit = false
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x:0, y: 0, width: 100, height: 100), type: NVActivityIndicatorType.BallClipRotateMultiple, color: UIColor.whiteColor(), size: CGSize(width: 100, height: 100))
    
    
    // Labels
    var lbMain: UILabel!
    var lbQuizName: UILabel!
    var lbOption1:UILabel!
    var lbOption2:UILabel!
    var lbOption3:UILabel!
    var lbOption4:UILabel!
    var lbAnswer:UILabel!
    
    // Text Field
    var tfQuizName: MKTextField!
    var tfOption1:MKTextField!
    var tfOption2:MKTextField!
    var tfOption3:MKTextField!
    var tfOption4:MKTextField!
    var tfAnswer:MKTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configBackButton()
        configScrollView()
        configViews()
        configActivity()
        //println(currentObject)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configBackButton() {
        // Back Button
        backButton.frame = CGRect(x: 10, y: 10, width: 40, height: 40)
        backButton.backgroundColor = UIColor.MKColor.Red
        backButton.cornerRadius = 20.0
        backButton.backgroundLayerCornerRadius = 20.0
        backButton.maskEnabled = false
        backButton.rippleLocation = .Center
        backButton.ripplePercent = 1.75
        backButton.layer.shadowOpacity = 0.75
        backButton.layer.shadowRadius = 3.5
        backButton.layer.shadowColor = UIColor.blackColor().CGColor
        backButton.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        //backButton.setImage(UIImage(named: "Close"), forState: UIControlState.Normal)
        //backButton.setTitle("X", forState: UIControlState.Normal)
        //backButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 20)
        backButton.addTarget(self, action: "backButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(backButton)
        self.view.bringSubviewToFront(backButton)
        
        //Transform effecr
        backButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
    }
    
    // Button Events
    func backButtonClick(button:UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func configScrollView(){
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.contentSize = CGSize(width: view.bounds.width, height: 1200)
        scrollView.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        self.scrollView.directionalLockEnabled = true
        scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.Interactive
        view.addSubview(scrollView)
        self.view.sendSubviewToBack(scrollView)
    }
    
    func configActivity() {
        self.activityIndicatorView.center = self.view.center
        self.view.addSubview(activityIndicatorView)
        self.view.bringSubviewToFront(activityIndicatorView)
        self.activityIndicatorView.hidden = true
    }
    
    func configViews(){
        // 1.Main Label
        lbMain = UILabel(frame: CGRect(x: 0, y: 5, width: self.view.frame.width, height: 30))
        lbMain.font = UIFont(name: "AvenirNext-Regular", size: 30)
        lbMain.textColor = UIColor.whiteColor()
        lbMain.textAlignment = .Center
        lbMain.text = lbMainText
        self.scrollView.addSubview(lbMain)
        view.addConstraint(NSLayoutConstraint(item:lbMain, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.scrollView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        
        // 2.Quiz Name Label
        lbQuizName = UILabel(frame: CGRect(x: 5, y: 0, width: self.view.frame.width/2, height: 20))
        lbQuizName.font = UIFont(name: "AvenirNext-Regular", size: 20)
        lbQuizName.textColor = UIColor.whiteColor()
        lbQuizName.textAlignment = .Left
        lbQuizName.text = "Quiz Question"
        self.scrollView.addSubview(lbQuizName)
        lbQuizName.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintLBName = NSLayoutConstraint(item: lbQuizName, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:lbMain, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 20)
        let leftConstraintLBName = NSLayoutConstraint(item: lbQuizName, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:scrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
        view.addConstraints([topConstraintLBName,leftConstraintLBName])
        
        // 3.Quiz Name TextField
        tfQuizName = MKTextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: 100))
        tfQuizName.layer.borderColor = UIColor.clearColor().CGColor
        tfQuizName.floatingPlaceholderEnabled = true
        tfQuizName.placeholder = "Question"
        tfQuizName.tintColor = UIColor.whiteColor()
        tfQuizName.textColor = UIColor.whiteColor()
        tfQuizName.rippleLocation = .Right
        tfQuizName.cornerRadius = 0
        tfQuizName.bottomBorderEnabled = true
        tfQuizName.borderStyle = UITextBorderStyle.None
        tfQuizName.minimumFontSize = 17
        tfQuizName.font = UIFont(name: "HelveticaNeue", size: 20)
        tfQuizName.clearButtonMode = UITextFieldViewMode.UnlessEditing
        tfQuizName.delegate = self
        self.scrollView.addSubview(tfQuizName)
        tfQuizName.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintTFName = NSLayoutConstraint(item: tfQuizName, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:lbQuizName, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 5)
        let leftConstraintTFName = NSLayoutConstraint(item: tfQuizName, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:scrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
        let widthConstraintTFName = NSLayoutConstraint(item: tfQuizName, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width-20)
        let heightConstraintTFName = NSLayoutConstraint(item: tfQuizName, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
        view.addConstraints([topConstraintTFName,leftConstraintTFName, widthConstraintTFName, heightConstraintTFName])

        // 4.Quiz Option 1 Label
        lbOption1 = UILabel(frame: CGRect(x: 5, y: 0, width: self.view.frame.width/2, height: 20))
        lbOption1.font = UIFont(name: "AvenirNext-Regular", size: 20)
        lbOption1.textColor = UIColor.whiteColor()
        lbOption1.textAlignment = .Left
        lbOption1.text = "Quiz Option 1"
        self.scrollView.addSubview(lbOption1)
        lbOption1.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintLB1 = NSLayoutConstraint(item: lbOption1, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:tfQuizName, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 20)
        let leftConstraintLB1 = NSLayoutConstraint(item: lbOption1, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:scrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
        view.addConstraints([topConstraintLB1,leftConstraintLB1])
        
        // 5.Quiz Option 1 TextField
        tfOption1 = MKTextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: 100))
        tfOption1.layer.borderColor = UIColor.clearColor().CGColor
        tfOption1.floatingPlaceholderEnabled = true
        tfOption1.placeholder = "Option 1"
        tfOption1.tintColor = UIColor.whiteColor()
        tfOption1.textColor = UIColor.whiteColor()
        tfOption1.rippleLocation = .Right
        tfOption1.cornerRadius = 0
        tfOption1.bottomBorderEnabled = true
        tfOption1.borderStyle = UITextBorderStyle.None
        tfOption1.minimumFontSize = 17
        tfOption1.font = UIFont(name: "HelveticaNeue", size: 20)
        tfOption1.clearButtonMode = UITextFieldViewMode.UnlessEditing
        tfOption1.delegate = self
        self.scrollView.addSubview(tfOption1)
        tfOption1.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintTF1 = NSLayoutConstraint(item: tfOption1, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:lbOption1, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 5)
        let leftConstraintTF1 = NSLayoutConstraint(item: tfOption1, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:scrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
        let widthConstraintTF1 = NSLayoutConstraint(item: tfOption1, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width-20)
        let heightConstraintTF1 = NSLayoutConstraint(item: tfOption1, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
        view.addConstraints([topConstraintTF1,leftConstraintTF1, widthConstraintTF1, heightConstraintTF1])
        
        // 6.Quiz Option 2 Label
        lbOption2 = UILabel(frame: CGRect(x: 5, y: 0, width: self.view.frame.width/2, height: 20))
        lbOption2.font = UIFont(name: "AvenirNext-Regular", size: 20)
        lbOption2.textColor = UIColor.whiteColor()
        lbOption2.textAlignment = .Left
        lbOption2.text = "Quiz Option 2"
        self.scrollView.addSubview(lbOption2)
        lbOption2.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintLB2 = NSLayoutConstraint(item: lbOption2, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:tfOption1, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 20)
        let leftConstraintLB2 = NSLayoutConstraint(item: lbOption2, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:scrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
        view.addConstraints([topConstraintLB2,leftConstraintLB2])
        
        // 7.Quiz Option 2 TextField
        tfOption2 = MKTextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: 100))
        tfOption2.layer.borderColor = UIColor.clearColor().CGColor
        tfOption2.floatingPlaceholderEnabled = true
        tfOption2.placeholder = "Option 2"
        tfOption2.tintColor = UIColor.whiteColor()
        tfOption2.textColor = UIColor.whiteColor()
        tfOption2.rippleLocation = .Right
        tfOption2.cornerRadius = 0
        tfOption2.bottomBorderEnabled = true
        tfOption2.borderStyle = UITextBorderStyle.None
        tfOption2.minimumFontSize = 17
        tfOption2.font = UIFont(name: "HelveticaNeue", size: 20)
        tfOption2.clearButtonMode = UITextFieldViewMode.UnlessEditing
        tfOption2.delegate = self
        self.scrollView.addSubview(tfOption2)
        tfOption2.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintTF2 = NSLayoutConstraint(item: tfOption2, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:lbOption2, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 5)
        let leftConstraintTF2 = NSLayoutConstraint(item: tfOption2, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:scrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
        let widthConstraintTF2 = NSLayoutConstraint(item: tfOption2, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width-20)
        let heightConstraintTF2 = NSLayoutConstraint(item: tfOption2, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
        view.addConstraints([topConstraintTF2,leftConstraintTF2, widthConstraintTF2, heightConstraintTF2])
        
        // 8.Quiz Option 3 Label
        lbOption3 = UILabel(frame: CGRect(x: 5, y: 0, width: self.view.frame.width/2, height: 20))
        lbOption3.font = UIFont(name: "AvenirNext-Regular", size: 20)
        lbOption3.textColor = UIColor.whiteColor()
        lbOption3.textAlignment = .Left
        lbOption3.text = "Quiz Option 3"
        self.scrollView.addSubview(lbOption3)
        lbOption3.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintLB3 = NSLayoutConstraint(item: lbOption3, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:tfOption2, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 20)
        let leftConstraintLB3 = NSLayoutConstraint(item: lbOption3, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:scrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
        view.addConstraints([topConstraintLB3,leftConstraintLB3])
        
        // 9.Quiz Option 3 TextField
        tfOption3 = MKTextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: 100))
        tfOption3.layer.borderColor = UIColor.clearColor().CGColor
        tfOption3.floatingPlaceholderEnabled = true
        tfOption3.placeholder = "Option 3"
        tfOption3.tintColor = UIColor.whiteColor()
        tfOption3.textColor = UIColor.whiteColor()
        tfOption3.rippleLocation = .Right
        tfOption3.cornerRadius = 0
        tfOption3.bottomBorderEnabled = true
        tfOption3.borderStyle = UITextBorderStyle.None
        tfOption3.minimumFontSize = 17
        tfOption3.font = UIFont(name: "HelveticaNeue", size: 20)
        tfOption3.clearButtonMode = UITextFieldViewMode.UnlessEditing
        tfOption3.delegate = self
        self.scrollView.addSubview(tfOption3)
        tfOption3.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintTF3 = NSLayoutConstraint(item: tfOption3, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:lbOption3, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 5)
        let leftConstraintTF3 = NSLayoutConstraint(item: tfOption3, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:scrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
        let widthConstraintTF3 = NSLayoutConstraint(item: tfOption3, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width-20)
        let heightConstraintTF3 = NSLayoutConstraint(item: tfOption3, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
        view.addConstraints([topConstraintTF3,leftConstraintTF3, widthConstraintTF3, heightConstraintTF3])
        
        // 10.Quiz Option 3 Label
        lbOption4 = UILabel(frame: CGRect(x: 5, y: 0, width: self.view.frame.width/2, height: 20))
        lbOption4.font = UIFont(name: "AvenirNext-Regular", size: 20)
        lbOption4.textColor = UIColor.whiteColor()
        lbOption4.textAlignment = .Left
        lbOption4.text = "Quiz Option 4"
        self.scrollView.addSubview(lbOption4)
        lbOption4.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintLB4 = NSLayoutConstraint(item: lbOption4, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:tfOption3, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 20)
        let leftConstraintLB4 = NSLayoutConstraint(item: lbOption4, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:scrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
        view.addConstraints([topConstraintLB4,leftConstraintLB4])
        
        // 11.Quiz Option 3 TextField
        tfOption4 = MKTextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: 100))
        tfOption4.layer.borderColor = UIColor.clearColor().CGColor
        tfOption4.floatingPlaceholderEnabled = true
        tfOption4.placeholder = "Option 4"
        tfOption4.tintColor = UIColor.whiteColor()
        tfOption4.textColor = UIColor.whiteColor()
        tfOption4.rippleLocation = .Right
        tfOption4.cornerRadius = 0
        tfOption4.bottomBorderEnabled = true
        tfOption4.borderStyle = UITextBorderStyle.None
        tfOption4.minimumFontSize = 17
        tfOption4.font = UIFont(name: "HelveticaNeue", size: 20)
        tfOption4.clearButtonMode = UITextFieldViewMode.UnlessEditing
        tfOption4.delegate = self
        self.scrollView.addSubview(tfOption4)
        tfOption4.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintTF4 = NSLayoutConstraint(item: tfOption4, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:lbOption4, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 5)
        let leftConstraintTF4 = NSLayoutConstraint(item: tfOption4, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:scrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
        let widthConstraintTF4 = NSLayoutConstraint(item: tfOption4, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width-20)
        let heightConstraintTF4 = NSLayoutConstraint(item: tfOption4, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
        view.addConstraints([topConstraintTF4,leftConstraintTF4, widthConstraintTF4, heightConstraintTF4])
        
        // 12.Quiz Option 3 Label
        lbAnswer = UILabel(frame: CGRect(x: 5, y: 0, width: self.view.frame.width/2, height: 20))
        lbAnswer.font = UIFont(name: "AvenirNext-Regular", size: 20)
        lbAnswer.textColor = UIColor.whiteColor()
        lbAnswer.textAlignment = .Left
        lbAnswer.text = "Quiz Answer"
        self.scrollView.addSubview(lbAnswer)
        lbAnswer.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintLBAnswer = NSLayoutConstraint(item: lbAnswer, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:tfOption4, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 20)
        let leftConstraintLBAnswer = NSLayoutConstraint(item: lbAnswer, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:scrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
        view.addConstraints([topConstraintLBAnswer,leftConstraintLBAnswer])
        
        // 13.Quiz Option 3 TextField
        tfAnswer = MKTextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: 100))
        tfAnswer.layer.borderColor = UIColor.clearColor().CGColor
        tfAnswer.floatingPlaceholderEnabled = true
        tfAnswer.placeholder = "Answer"
        tfAnswer.tintColor = UIColor.whiteColor()
        tfAnswer.textColor = UIColor.whiteColor()
        tfAnswer.rippleLocation = .Right
        tfAnswer.cornerRadius = 0
        tfAnswer.bottomBorderEnabled = true
        tfAnswer.borderStyle = UITextBorderStyle.None
        tfAnswer.minimumFontSize = 17
        tfAnswer.font = UIFont(name: "HelveticaNeue", size: 20)
        tfAnswer.keyboardType = UIKeyboardType.NumberPad
        tfAnswer.clearButtonMode = UITextFieldViewMode.UnlessEditing
        tfAnswer.delegate = self
        self.scrollView.addSubview(tfAnswer)
        tfAnswer.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintTFAnswer = NSLayoutConstraint(item: tfAnswer, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:lbAnswer, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 5)
        let leftConstraintTFAnswer = NSLayoutConstraint(item: tfAnswer, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:scrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
        let widthConstraintTFAnswer = NSLayoutConstraint(item: tfAnswer, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width-20)
        let heightConstraintTFAnswer = NSLayoutConstraint(item: tfAnswer, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
        view.addConstraints([topConstraintTFAnswer,leftConstraintTFAnswer, widthConstraintTFAnswer, heightConstraintTFAnswer])
        
        // 16.Promotion Commit Button
        commitButton = MKButton(frame: CGRect(x: 5, y: 0, width: self.view.frame.width/2-10, height: 50))
        commitButton.layer.shadowOpacity = 0.55
        commitButton.layer.shadowRadius = 5.0
        commitButton.layer.shadowColor = UIColor.blackColor().CGColor
        commitButton.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        commitButton.backgroundColor = UIColor.MKColor.Blue
        commitButton.setTitle("Commit", forState: UIControlState.Normal)
        commitButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        commitButton.addTarget(self, action: "commitButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.scrollView.addSubview(commitButton)
        commitButton.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintBTCommit = NSLayoutConstraint(item: commitButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:tfAnswer, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 20)
        let leftConstraintBTCommit = NSLayoutConstraint(item: commitButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:scrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
        let widthConstraintBTCommit = NSLayoutConstraint(item: commitButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width-20)
        let heightConstraintBTCommit = NSLayoutConstraint(item: commitButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
        view.addConstraints([topConstraintBTCommit,leftConstraintBTCommit, widthConstraintBTCommit, heightConstraintBTCommit])
    }

    func commitButtonClick(button: UIButton) {
        print("Commit Button Touched")
        if tfQuizName.text == "" {
            let missAlertViewController:NYAlertViewController = NYAlertViewController()
            missAlertViewController.addAction(NYAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            missAlertViewController.title = "Missing"
            missAlertViewController.message = "Please fill Quiz Question!"
            missAlertViewController.titleColor = UIColor.MKColor.Orange
            self.presentViewController(missAlertViewController, animated: true, completion: nil)
        } else if tfOption1.text == "" || tfOption2.text == "" || tfOption3.text == "" || tfOption4.text == "" {
            let missAlertViewController:NYAlertViewController = NYAlertViewController()
            missAlertViewController.addAction(NYAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            missAlertViewController.title = "Missing"
            missAlertViewController.message = "Please fill at least 1 option!"
            missAlertViewController.titleColor = UIColor.MKColor.Orange
            self.presentViewController(missAlertViewController, animated: true, completion: nil)
        } else {
            //Everything's Ok
            // Prevent user hit buttons previously
            self.commitButton.userInteractionEnabled = false
            // Show activityIndicatior
            self.activityIndicatorView.hidden = false
            self.activityIndicatorView.startAnimation()
            let object = PFObject(className: "Quizzes")
            object.setObject(tfQuizName.text!, forKey: "QuizQuestion")
            object.setObject(tfOption1.text!, forKey: "Option1")
            object.setObject(tfOption2.text!, forKey: "Option2")
            object.setObject(tfOption3.text!, forKey: "Option3")
            object.setObject(tfOption4.text!, forKey: "Option4")
            object.setObject(tfAnswer.text!, forKey: "Answer")
            object.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
                //
                if succeeded {
                    // Allow user hit commit buttons
                    self.commitButton.userInteractionEnabled = true
                    self.activityIndicatorView.stopAnimation()
                    self.activityIndicatorView.hidden = true
                    let successAlertViewController:NYAlertViewController = NYAlertViewController()
                    successAlertViewController.addAction(NYAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }))
                    successAlertViewController.title = "Successful"
                    successAlertViewController.message = "You successfully created new quiz!"
                    successAlertViewController.titleColor = UIColor.MKColor.Orange
                    successAlertViewController.buttonColor = UIColor.MKColor.Green
                    successAlertViewController.buttonTitleColor = UIColor(white: 0.19, alpha: 1.0)
                    self.presentViewController(successAlertViewController, animated: true, completion: nil)
                }
            })
        }
        
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
