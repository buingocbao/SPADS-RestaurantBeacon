//
//  SettingViewController.swift
//  SPADS-RestaurantBeacon
//
//  Created by BBaoBao on 8/5/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tfAccount: MKTextField!
    @IBOutlet weak var tfPass: MKTextField!
    @IBOutlet weak var btLogin: MKButton!
    @IBOutlet weak var btRegister: MKButton!
    @IBOutlet weak var btForget: MKButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidAppear(animated: Bool) {
        activityIndicator.stopAnimating()
        
        //Check current user
        let currentUser = PFUser.currentUser()
        if currentUser != nil {
            tfAccount.text = currentUser?.username
            tfPass.text = currentUser?.password
            activityIndicator.hidden = false
            activityIndicator.startAnimating()
            self.tabBarController?.selectedIndex = 1
            //self.performSegueWithIdentifier("LoginSegue", sender: false)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // get a frame calculation ready
        let frame = self.tabBarController?.tabBar.frame
        let height = frame?.size.height
        let offsetY = height!
        self.tabBarController?.tabBar.frame = CGRectOffset(frame!, 0, offsetY)
        /*
        //Motion Background
        // Make Motion background
        var backgroundImage:UIImageView = UIImageView(frame: CGRect(x: -50, y: -50, width: dvWidth+100, height: dvHeight+100))
        backgroundImage.image = UIImage(named: "Background.jpg")
        backgroundImage.contentMode = UIViewContentMode.ScaleAspectFit
        self.view.addSubview(backgroundImage)
        self.view.sendSubviewToBack(backgroundImage)
        
        let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
        horizontalMotionEffect.minimumRelativeValue = -50
        horizontalMotionEffect.maximumRelativeValue = 50
        
        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = -50
        verticalMotionEffect.maximumRelativeValue = 50
        
        let motionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [horizontalMotionEffect, verticalMotionEffect]
        
        backgroundImage.addMotionEffect(motionEffectGroup)
        */
        
        // Email textfield
        tfAccount.layer.borderColor = UIColor.clearColor().CGColor
        tfAccount.floatingPlaceholderEnabled = true
        tfAccount.placeholder = "Email Account"
        //tfAccount.circleLayerColor = UIColor.MKColor.LightGreen
        tfAccount.tintColor = UIColor.MKColor.Green
        tfAccount.backgroundColor = UIColor(hex: 0xE0E0E0)
        self.view.bringSubviewToFront(tfAccount)
        self.tfAccount.delegate = self
        
        // Password Textfield
        tfPass.layer.borderColor = UIColor.clearColor().CGColor
        tfPass.floatingPlaceholderEnabled = true
        tfPass.placeholder = "Password"
        //tfPassword.circleLayerColor = UIColor.MKColor.LightGreen
        tfPass.tintColor = UIColor.MKColor.Green
        tfPass.backgroundColor = UIColor(hex: 0xE0E0E0)
        self.view.bringSubviewToFront(tfPass)
        self.tfPass.delegate = self
        
        // Login Button
        //btLogin.cornerRadius = 40.0
        //btLogin.backgroundLayerCornerRadius = 40.0
        //btLogin.maskEnabled = false
        //btLogin.ripplePercent = 1.75
        //btLogin.rippleLocation = .Center
        
        btLogin.layer.shadowOpacity = 0.75
        btLogin.layer.shadowRadius = 3.5
        btLogin.layer.shadowColor = UIColor.blackColor().CGColor
        btLogin.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        
        // Register Button
        //btRegister.cornerRadius = 40.0
        //btRegister.backgroundLayerCornerRadius = 40.0
        //btRegister.maskEnabled = false
        //btRegister.ripplePercent = 1.75
        //btRegister.rippleLocation = .Center
        
        //btRegister.layer.shadowOpacity = 0.75
        //btRegister.layer.shadowRadius = 3.5
        //btRegister.layer.shadowColor = UIColor.blackColor().CGColor
        //btRegister.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        
        // Forgot password button
        //self.view.bringSubviewToFront(btRegister)
        
        btForget.layer.shadowOpacity = 0.75
        btForget.layer.shadowRadius = 3.5
        btForget.layer.shadowColor = UIColor.blackColor().CGColor
        btForget.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        
        // Progress icon for logging
        self.view.bringSubviewToFront(activityIndicator)
        activityIndicator.hidden = true
        activityIndicator.hidesWhenStopped = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        checkLogin()
        return true;
    }
    
    func checkLogin() {
        // Start activity indicator
        self.view.userInteractionEnabled = false
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        // The textfields are not completed
        if (self.tfAccount.text == "") || (self.tfPass.text == "") {
            let alert = UIAlertController(title: "Login Failed", message: "Please fill your email and password", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        PFUser.logInWithUsernameInBackground(tfAccount.text!, password:tfPass.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    // MARK: Login successfully
                    self.view.userInteractionEnabled = true
                    self.activityIndicator.stopAnimating()
                    self.view.endEditing(true)
                    //self.performSegueWithIdentifier("PerformSettingSegue", sender: nil)
                    self.tabBarController?.selectedIndex = 1
                    /*
                    // Get views. controllerIndex is passed in as the controller we want to go to.
                    var fromView = tabBarController?.selectedViewController.
                    UIView * fromView = tabBarController.selectedViewController.view;
                    UIView * toView = [[tabBarController.viewControllers objectAtIndex:controllerIndex] view];
                    
                    // Transition using a page curl.
                    [UIView transitionFromView:fromView
                        toView:toView
                        duration:0.5
                        options:(controllerIndex > tabBarController.selectedIndex ? UIViewAnimationOptionTransitionCurlUp : UIViewAnimationOptionTransitionCurlDown)
                        completion:^(BOOL finished) {
                        if (finished) {
                        tabBarController.selectedIndex = controllerIndex;
                        }
                        }];

                    */
                }
                self.tfAccount.text = ""
                self.tfPass.text = ""
            } else {
                // The login failed. Check error to see why.
                let alert = UIAlertController(title: "Login Failed", message: "There is a problem when log in to your account. First, please check your email and password. Second, please check you network connection. Then try again. If everything above is OK, please contact to managers", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
            }
        }
        tfAccount.placeholder = "Email Account"
        catchLoginEvent()
    }
    
    func catchLoginEvent() {
        btLogin.addTarget(self, action: "btLogin:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func processSignUp() {
        var userEmailAddress = tfAccount.text
        let userPassword = tfPass.text
        
        // Ensure username is lowercase
        userEmailAddress = userEmailAddress!.lowercaseString
        
        // Add email address validation
        
        // Start activity indicator
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        // Create the user
        let user = PFUser()
        user.username = userEmailAddress
        user.password = userPassword
        user.email = userEmailAddress
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if error == nil {
                self.activityIndicator.stopAnimating()
                dispatch_async(dispatch_get_main_queue()) {
                    self.activityIndicator.stopAnimating()
                    self.view.endEditing(true)
                    self.performSegueWithIdentifier("PerformSettingSegue", sender: nil)
                }
                self.tfAccount.text = ""
                self.tfPass.text = ""
            } else {
                self.activityIndicator.stopAnimating()
                if let message: AnyObject = error!.userInfo["error"] {
                    let alert = UIAlertController(title: "Register Failed", message: message as? String, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
        
        tfAccount.placeholder = "Email Account"
    }
    
    // MARK: Check validate email
    func validate(value: String) -> Bool {
        let emailRule = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", emailRule)
        return phoneTest.evaluateWithObject(value)
    }
    
    // MARK: - Button Event
    
    @IBAction func btLogin(sender: AnyObject) {
        checkLogin()
    }
    
    @IBAction func btRegister(sender: AnyObject) {
        if (self.tfAccount.text == "") || (self.tfPass.text == "") {
            let alert = UIAlertController(title: "Register Failed", message: "Please fill your email and password", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            // Build the terms and conditions alert
            let alertController = UIAlertController(title: "Agree to terms and conditions",
                message: "Click I AGREE to signal that you agree to the End User Licence Agreement.",
                preferredStyle: UIAlertControllerStyle.Alert
            )
            alertController.addAction(UIAlertAction(title: "I AGREE",
                style: UIAlertActionStyle.Default,
                handler: { alertController in self.processSignUp()})
            )
            alertController.addAction(UIAlertAction(title: "I do NOT agree",
                style: UIAlertActionStyle.Default,
                handler: nil)
            )
            // Display alert
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func btForget(sender: AnyObject) {
        if tfAccount.text == "" {
            //tfAccount.placeholder = "To reset password, please enter email"
            let alert = UIAlertController(title: "Forget Password", message: "Please enter your email to Email Account textfield, then touch Forget password again.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            if validate(tfAccount.text!) {
                tfAccount.textColor = UIColor.blackColor()
                tfAccount.placeholder = "Email Account"
                PFUser.requestPasswordResetForEmailInBackground(tfAccount.text!)
                let alert = UIAlertController(title: "Forget Password", message: "Please check your email to continue resetting process", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                tfAccount.placeholder = "Email Account"
                self.btForget?.hidden = true
                self.btForget?.enabled = false
                _ = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: "updateForgotButton", userInfo: nil, repeats: false)
            } else {
                tfAccount.textColor = UIColor.redColor()
            }
        }
    }
    
    func updateForgotButton() {
        UIView.transitionWithView(btForget!, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            //
            self.btForget?.hidden = false
            self.btForget?.enabled = true
        }, completion: nil)
    }
    
    // MARK: - Other functions
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        tfAccount.textColor = UIColor.blackColor()
        tfAccount.placeholder = "Email Account"
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
