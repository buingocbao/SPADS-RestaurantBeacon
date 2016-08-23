//
//  SettingMenuViewController.swift
//  SPADS-RestaurantBeacon
//
//  Created by BBaoBao on 8/13/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class SettingMenuViewController: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var promotionSettingButton: UIButton!
    @IBOutlet weak var productSettingButton: UIButton!
    @IBOutlet weak var notificationSettingButton: UIButton!
    @IBOutlet weak var quizSettingButton: UIButton!
    @IBOutlet weak var pushNoti: MKButton!
    
    var touchButton:String = ""
    var backButton:MKButton = MKButton()
    
    let transition = BubbleTransition()
    
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x:0, y: 0, width: 200, height: 200), type: NVActivityIndicatorType.BallClipRotateMultiple, color: UIColor.whiteColor(), size: CGSize(width: 200, height: 200))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configButtons()
        configBackButton()
        createActivityIndicatorView()
        // Do any additional setup after loading the view.
    }
    
    func configBackButton() {
        // Back Button
        backButton.frame = CGRect(x: 10, y: 60, width: 100, height: 40)
        backButton.backgroundColor = UIColor.MKColor.Red
        backButton.layer.shadowOpacity = 0.75
        backButton.layer.shadowRadius = 3.5
        backButton.layer.shadowColor = UIColor.blackColor().CGColor
        backButton.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        //backButton.setImage(UIImage(named: "Close"), forState: UIControlState.Normal)
        backButton.setTitle("Logout", forState: UIControlState.Normal)
        //backButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 20)
        backButton.addTarget(self, action: "backButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(backButton)
        self.view.bringSubviewToFront(backButton)

    }
    
    func backButtonClick(button:UIButton) {
        self.view.userInteractionEnabled = false
        self.activityIndicatorView.hidden = false
        self.activityIndicatorView.startAnimation()
        PFUser.logOutInBackgroundWithBlock { (error) -> Void in
            if error == nil {
                self.view.userInteractionEnabled = true
                self.activityIndicatorView.hidden = true
                self.activityIndicatorView.stopAnimation()
                self.tabBarController?.selectedIndex = 0
            }
        }
    }
    
    func configButtons() {
        promotionSettingButton.layer.shadowOpacity = 0.75
        promotionSettingButton.layer.shadowRadius = 3.5
        promotionSettingButton.layer.shadowColor = UIColor.blackColor().CGColor
        promotionSettingButton.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        
        productSettingButton.layer.shadowOpacity = 0.75
        productSettingButton.layer.shadowRadius = 3.5
        productSettingButton.layer.shadowColor = UIColor.blackColor().CGColor
        productSettingButton.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        
        notificationSettingButton.layer.shadowOpacity = 0.75
        notificationSettingButton.layer.shadowRadius = 3.5
        notificationSettingButton.layer.shadowColor = UIColor.blackColor().CGColor
        notificationSettingButton.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        
        quizSettingButton.layer.shadowOpacity = 0.75
        quizSettingButton.layer.shadowRadius = 3.5
        quizSettingButton.layer.shadowColor = UIColor.blackColor().CGColor
        quizSettingButton.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        
        pushNoti.layer.shadowOpacity = 0.75
        pushNoti.layer.shadowRadius = 3.5
        pushNoti.layer.shadowColor = UIColor.blackColor().CGColor
        pushNoti.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        
    }
    
    func createActivityIndicatorView() {
        activityIndicatorView.center = self.view.center
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.hidden = true
        activityIndicatorView.stopAnimation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        /*
        if let controller = segue.destinationViewController as? UIViewController {
            controller.transitioningDelegate = self
            controller.modalPresentationStyle = .Custom
        }*/
        let controller = segue.destinationViewController
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .Custom
    }

    // MARK: UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Present
        switch touchButton {
        case "Promotion":
            //
            transition.startingPoint = promotionSettingButton.center
            transition.bubbleColor = promotionSettingButton.backgroundColor!
        case "Product":
            //
            transition.startingPoint = productSettingButton.center
            transition.bubbleColor = productSettingButton.backgroundColor!
        case "Noti":
            //
            transition.startingPoint = notificationSettingButton.center
            transition.bubbleColor = notificationSettingButton.backgroundColor!
        case "Quiz":
            //
            transition.startingPoint = quizSettingButton.center
            transition.bubbleColor = quizSettingButton.backgroundColor!
        default:
            break
        }
        
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Dismiss
        switch touchButton {
        case "Promotion":
            //
            transition.startingPoint = promotionSettingButton.center
            transition.bubbleColor = promotionSettingButton.backgroundColor!
        case "Product":
            //
            transition.startingPoint = productSettingButton.center
            transition.bubbleColor = productSettingButton.backgroundColor!
        case "Noti":
            //
            transition.startingPoint = notificationSettingButton.center
            transition.bubbleColor = notificationSettingButton.backgroundColor!
        case "Quiz":
            //
            transition.startingPoint = quizSettingButton.center
            transition.bubbleColor = quizSettingButton.backgroundColor!
        default:
            break
        }
        return transition
    }
    
    // MARK : Button Event
    
    @IBAction func promotionTouchDown(sender: AnyObject) {
        touchButton = "Promotion"
    }
    @IBAction func productTouchDown(sender: AnyObject) {
        touchButton = "Product"
    }
    @IBAction func notiTouchDown(sender: AnyObject) {
        touchButton = "Noti"
    }
    @IBAction func quizTouchDown(sender: AnyObject) {
        touchButton = "Quiz"
    }
    @IBAction func pushNotiTouchDown(sender: AnyObject) {
        let popoverViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PushNotiVC") as! AddNotiPushViewController
        popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
        popoverViewController.popoverPresentationController!.delegate = self
        popoverViewController.preferredContentSize = CGSizeMake(300 , 150)
        let popover = popoverViewController.popoverPresentationController
        
        //let popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("PushNotiVC") as! AddNotiPushViewController
        //let nav = UINavigationController(rootViewController: popoverContent)
        //nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        //let popover = nav.popoverPresentationController
        //popoverContent.preferredContentSize = CGSizeMake(300 , 150)
        popover!.delegate = self
        popover!.sourceView = pushNoti
        popover!.sourceRect = CGRectMake(pushNoti!.frame.width/2,0,0,0)
        self.presentViewController(popoverViewController, animated: true, completion: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

extension SettingMenuViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController) -> UIModalPresentationStyle {
            return .None
    }
}
