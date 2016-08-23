//
//  QuizSettingViewController.swift
//  SPADS-RestaurantBeacon
//
//  Created by BBaoBao on 8/13/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class QuizSettingViewController: UIViewController, UIViewControllerTransitioningDelegate {

    var backButton: MKButton = MKButton()
    var quizzesArray: NSArray = NSArray()
    var quizzesDic = Dictionary<String,[String]>()
    
    let transition = BubbleTransition()
    
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configBackButton()
        configAddButton()
        queryParseMethod()
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
    
    func configAddButton() {
        addButton.layer.shadowOpacity = 0.75
        addButton.layer.shadowRadius = 3.5
        addButton.layer.shadowColor = UIColor.blackColor().CGColor
        addButton.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
    }
    
    func queryParseMethod() {
        let query = PFQuery(className: "Quizzes")
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) quizzes.")
                self.quizzesArray = objects!
                print(self.quizzesArray)
                for i in 0...(self.quizzesArray.count-1) {
                    let quizObject:PFObject = self.quizzesArray.objectAtIndex(i) as! PFObject
                    var answerArray = [String]()
                    if let option1 = quizObject["Option1"] as? String {
                        answerArray.append(option1)
                    }
                    if let option2 = quizObject["Option2"] as? String {
                        answerArray.append(option2)
                    }
                    if let option3 = quizObject["Option3"] as? String {
                        answerArray.append(option3)
                    }
                    if let option4 = quizObject["Option4"] as? String {
                        answerArray.append(option4)
                    }
                    if let answer = quizObject["Answer"] as? String {
                        answerArray.append(answer)
                    }
                    self.quizzesDic["Question\(i)"] = answerArray
                }
                print(self.quizzesDic)
                print(self.quizzesDic.count)
            }
        }

    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? AddQuizViewController {
            controller.transitioningDelegate = self
            controller.modalPresentationStyle = .Custom
            controller.lbMainText = "Add Quiz"
        }
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Present
        transition.startingPoint = addButton.center
        transition.bubbleColor = addButton.backgroundColor!
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Dismiss
        transition.startingPoint = addButton.center
        transition.bubbleColor = addButton.backgroundColor!
        return transition
    }
}
