//
//  AddNotiPushViewController.swift
//  SPADS-RestaurantBeacon
//
//  Created by BBaoBao on 9/21/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import UIKit

class AddNotiPushViewController: UIViewController {

    var tfNotiString:MKTextField!
    var submitButton: MKButton = MKButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "Provide your message"
        self.view.backgroundColor = .clearColor()
        // Config textfield
        tfNotiString = MKTextField(frame: CGRect(x: 0, y: 20, width: 300, height: 40))
        tfNotiString.layer.borderColor = UIColor.clearColor().CGColor
        tfNotiString.floatingPlaceholderEnabled = true
        tfNotiString.placeholder = "Message"
        tfNotiString.tintColor = UIColor.whiteColor()
        tfNotiString.textColor = UIColor.blackColor()
        tfNotiString.rippleLocation = .Right
        tfNotiString.cornerRadius = 0
        tfNotiString.bottomBorderEnabled = true
        tfNotiString.borderStyle = UITextBorderStyle.None
        tfNotiString.minimumFontSize = 17
        tfNotiString.font = UIFont(name: "HelveticaNeue", size: 20)
        tfNotiString.clearButtonMode = UITextFieldViewMode.UnlessEditing
        self.view.addSubview(tfNotiString)
        
        //Config button
        // Back Button
        submitButton.frame = CGRect(x: 0, y: 60 + 20, width: 300, height: 40)
        submitButton.backgroundColor = UIColor.MKColor.Red
        submitButton.cornerRadius = 10.0
        submitButton.backgroundLayerCornerRadius = 20.0
        submitButton.maskEnabled = false
        submitButton.backgroundAniEnabled = true
        submitButton.rippleLocation = .Center
        submitButton.ripplePercent = 1.75
        submitButton.setTitle("Submit", forState: UIControlState.Normal)
        submitButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 20)
        submitButton.addTarget(self, action: "submitButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(submitButton)
        self.view.bringSubviewToFront(submitButton)
    }
    
    func submitButtonClick() {
        if tfNotiString.text != "" {
            self.view.userInteractionEnabled = false
            let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x:0, y: 0, width: 300, height: 150), type: NVActivityIndicatorType.BallClipRotateMultiple, color: UIColor.whiteColor(), size: CGSize(width: 80, height: 80))
            self.view.addSubview(activityIndicatorView)
            activityIndicatorView.startAnimation()
            let query = PFQuery(className: "Restaurant")
            let currentUser = PFUser.currentUser()
            let restaurantID = currentUser?.objectForKey("Restaurant") as! String
            query.getObjectInBackgroundWithId(restaurantID, block: { (object, error) -> Void in
                if error == nil {
                    let restaurantName = object?.objectForKey("RestaurantName") as! String
                    let push = PFPush()
                    push.setChannel("global")
                    push.setMessage(restaurantName + ": " + self.tfNotiString.text!)
                    push.sendPushInBackgroundWithBlock({ (succeeded, error) -> Void in
                        if succeeded {
                            activityIndicatorView.stopAnimation()
                            activityIndicatorView.hidden = true
                            let alert = UIAlertController(title: "Success", message: "Your message will provide to customers soon. Thank you!", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }))
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    })
                }
            })
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
