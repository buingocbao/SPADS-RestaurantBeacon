//
//  MenuViewController.swift
//  SPADS-RestaurantBeacon
//
//  Created by BBaoBao on 8/5/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var foodButton: MKButton!
    @IBOutlet weak var drinkButton: MKButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configButton()
    }
    
    func configButton() {
        foodButton.maskEnabled = false
        foodButton.ripplePercent = 1.2
        foodButton.backgroundAniEnabled = false
        foodButton.rippleLocation = .Center
        
        drinkButton.maskEnabled = false
        drinkButton.ripplePercent = 1.2
        drinkButton.backgroundAniEnabled = false
        drinkButton.rippleLocation = .Center
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: Button event
    @IBAction func btFoodEvent(sender: AnyObject) {
        
    }
    
    @IBAction func btDrinkEvent(sender: AnyObject) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FoodSegue" {
            let navVC = segue.destinationViewController as! UINavigationController
            let swiftCardView = navVC.viewControllers.first as! SwiftCardViewController
            swiftCardView.pickedMenu = "food.png"
        }
        
        if segue.identifier == "DrinkSegue" {
            let navVC = segue.destinationViewController as! UINavigationController
            let swiftCardView = navVC.viewControllers.first as! SwiftCardViewController
            swiftCardView.pickedMenu = "drink.png"
        }
    }

}
