//
//  DetailViewController.swift
//  SPADS-RestaurantBeacon
//
//  Created by BBaoBao on 9/3/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class DetailViewController: SADetailViewController {
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var foodButton:MKButton = MKButton()
    var drinkButton:MKButton = MKButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        configButton()
    }
    
    func configButton() {
        let buttonSize:CGFloat = 150.0
        foodButton.frame = CGRect(x: self.view.frame.width/2-buttonSize-5, y: self.view.frame.height-buttonSize-10, width: buttonSize, height: buttonSize)
        foodButton.backgroundColor = UIColor.MKColor.Red
        foodButton.cornerRadius = buttonSize/2
        foodButton.backgroundLayerCornerRadius = buttonSize/2
        foodButton.maskEnabled = false
        foodButton.rippleLocation = .Center
        foodButton.ripplePercent = 1.75
        foodButton.layer.shadowOpacity = 0.75
        foodButton.layer.shadowRadius = 3.5
        foodButton.layer.shadowColor = UIColor.blackColor().CGColor
        foodButton.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        foodButton.setImage(UIImage(named: "food.png"), forState: UIControlState.Normal)
        foodButton.addTarget(self, action: "foodButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(foodButton)
        
        drinkButton.frame = CGRect(x: self.view.frame.width/2+5, y: self.view.frame.height-buttonSize-10, width: buttonSize, height: buttonSize)
        drinkButton.backgroundColor = UIColor.MKColor.Red
        drinkButton.cornerRadius = buttonSize/2
        drinkButton.backgroundLayerCornerRadius = buttonSize/2
        drinkButton.maskEnabled = false
        drinkButton.rippleLocation = .Center
        drinkButton.ripplePercent = 1.75
        drinkButton.layer.shadowOpacity = 0.75
        drinkButton.layer.shadowRadius = 3.5
        drinkButton.layer.shadowColor = UIColor.blackColor().CGColor
        drinkButton.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        drinkButton.setImage(UIImage(named: "drink.png"), forState: UIControlState.Normal)
        drinkButton.addTarget(self, action: "drinkButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(drinkButton)
    }
    
    func foodButtonClick(button: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let swiftCardVC:SwiftCardViewController = storyboard.instantiateViewControllerWithIdentifier("SwiftCardVC") as! SwiftCardViewController
        swiftCardVC.pickedMenu = "food.png"
        swiftCardVC.restaurantID = self.restaurantID
        let navigationController = UINavigationController(rootViewController: swiftCardVC)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func drinkButtonClick(button: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let swiftCardVC:SwiftCardViewController = storyboard.instantiateViewControllerWithIdentifier("SwiftCardVC") as! SwiftCardViewController
        swiftCardVC.pickedMenu = "drink.png"
        swiftCardVC.restaurantID = self.restaurantID
        let navigationController = UINavigationController(rootViewController: swiftCardVC)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
}
