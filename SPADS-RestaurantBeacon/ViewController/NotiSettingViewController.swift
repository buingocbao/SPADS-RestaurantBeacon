//
//  NotiSettingViewController.swift
//  SPADS-RestaurantBeacon
//
//  Created by BBaoBao on 8/13/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class NotiSettingViewController: UIViewController, UITextFieldDelegate {

    var backButton: MKButton = MKButton()
    var notiArray:NSArray = NSArray()
    @IBOutlet weak var tfWelcome: MKTextField!
    @IBOutlet weak var tfGoodbye: MKTextField!
    @IBOutlet weak var btUpdate: MKButton!
    
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x:0, y: 0, width: 100, height: 100), type: NVActivityIndicatorType.BallClipRotateMultiple, color: UIColor.whiteColor(), size: CGSize(width: 100, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTextFieldandButton()
        configActivity()
        configBackButton()
        queryParseMethod()
    }
    
    func configTextFieldandButton() {
        tfWelcome.delegate = self
        tfWelcome.floatingPlaceholderEnabled = true
        tfWelcome.placeholder = "Welcome"
        tfWelcome.tintColor = UIColor.whiteColor()
        tfWelcome.textColor = UIColor.whiteColor()
        tfWelcome.rippleLocation = .Right
        tfWelcome.cornerRadius = 0
        tfWelcome.bottomBorderEnabled = true
        tfWelcome.borderStyle = UITextBorderStyle.None
        tfWelcome.minimumFontSize = 17
        tfWelcome.font = UIFont(name: "HelveticaNeue", size: 20)
        tfWelcome.clearButtonMode = UITextFieldViewMode.UnlessEditing
        
        tfGoodbye.delegate = self
        tfGoodbye.floatingPlaceholderEnabled = true
        tfGoodbye.placeholder = "Goodbye"
        tfGoodbye.tintColor = UIColor.whiteColor()
        tfGoodbye.textColor = UIColor.whiteColor()
        tfGoodbye.rippleLocation = .Right
        tfGoodbye.cornerRadius = 0
        tfGoodbye.bottomBorderEnabled = true
        tfGoodbye.borderStyle = UITextBorderStyle.None
        tfGoodbye.minimumFontSize = 17
        tfGoodbye.font = UIFont(name: "HelveticaNeue", size: 20)
        tfGoodbye.clearButtonMode = UITextFieldViewMode.UnlessEditing
        
        btUpdate.layer.shadowOpacity = 0.55
        btUpdate.layer.shadowRadius = 5.0
        btUpdate.layer.shadowColor = UIColor.grayColor().CGColor
        btUpdate.layer.shadowOffset = CGSize(width: 0, height: 2.5)
    }
    
    func configActivity() {
        // Show activityIndicatior
        self.activityIndicatorView.center = self.view.center
        self.view.addSubview(activityIndicatorView)
        self.view.bringSubviewToFront(activityIndicatorView)
        self.activityIndicatorView.startAnimation()
    }
    
    func queryParseMethod() {
        //println("Start query")
        tfWelcome.userInteractionEnabled = false
        tfGoodbye.userInteractionEnabled = false
        btUpdate.userInteractionEnabled = false
        var restaurantID = ""
        if let restaurant = PFUser.currentUser()!["Restaurant"] as? String {
            restaurantID = restaurant
        }
        let query = PFQuery(className: "Notification").whereKey("Restaurant", equalTo: restaurantID)
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) notifications.")
                self.notiArray = objects!
                let notiObject:PFObject = self.notiArray.objectAtIndex(0) as! PFObject
                if let welSentence = notiObject["EnterRegion"] as? String {
                    self.tfWelcome.text = welSentence
                }
                if let gbSentence = notiObject["ExitRegion"] as? String {
                    self.tfGoodbye.text = gbSentence
                }
                self.activityIndicatorView.stopAnimation()
                self.activityIndicatorView.hidden = true
                self.tfWelcome.userInteractionEnabled = true
                self.tfGoodbye.userInteractionEnabled = true
                self.btUpdate.userInteractionEnabled = true
            }
        }
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
    
    func backButtonClick(button:UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    @IBAction func btUpdateTouchDown(sender: AnyObject) {
        btUpdate.userInteractionEnabled = false
        activityIndicatorView.hidden = false
        activityIndicatorView.startAnimation()
        let notiObject:PFObject = self.notiArray.objectAtIndex(0) as! PFObject
        notiObject["EnterRegion"] = tfWelcome.text
        notiObject["ExitRegion"] = tfGoodbye.text
        notiObject.saveInBackgroundWithBlock { (succeeded, error) -> Void in
            if succeeded {
                self.btUpdate.userInteractionEnabled = true
                self.activityIndicatorView.stopAnimation()
                self.activityIndicatorView.hidden = true
                let successAlertViewController:NYAlertViewController = NYAlertViewController()
                successAlertViewController.addAction(NYAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                }))
                successAlertViewController.title = "Successful"
                successAlertViewController.message = "You successfully updated notifications!"
                successAlertViewController.titleColor = UIColor.MKColor.Orange
                successAlertViewController.buttonColor = UIColor.MKColor.Green
                successAlertViewController.buttonTitleColor = UIColor(white: 0.19, alpha: 1.0)
                self.presentViewController(successAlertViewController, animated: true, completion: nil)
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField === tfWelcome) {
            tfGoodbye.becomeFirstResponder()
        } else if textField === tfGoodbye {
            tfGoodbye.resignFirstResponder()
        }
        return true
    }
}
