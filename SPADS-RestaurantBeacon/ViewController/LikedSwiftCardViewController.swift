//
//  LikedSwiftCardViewController.swift
//  SPADS-RestaurantBeacon
//
//  Created by BBaoBao on 8/17/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit
import performSelector_swift
import UIColor_FlatColors
import Cartography
import ReactiveUI
import ZLSwipeableViewSwift

class LikedSwiftCardViewController: UIViewController, CardViewProtocol {
    
    var backButton: MKButton = MKButton()
    var reloadButton: MKButton = MKButton()
    
    var swipeableView: ZLSwipeableView!
    var colors = ["Turquoise", "Green Sea", "Emerald", "Nephritis", "Peter River", "Belize Hole", "Amethyst", "Wisteria", "Wet Asphalt", "Midnight Blue", "Sun Flower", "Orange", "Carrot", "Pumpkin", "Alizarin", "Pomegranate", "Clouds", "Silver", "Concrete", "Asbestos"]
    var colorIndex = 0
    var productIndex = 0
    var loadCardsFromXib = false
    
    var allArrayObject:NSMutableArray = NSMutableArray()
    var likedArrayObject = [PFObject]()
    var arrayObject = [PFObject]()
    var pickedMenu:String = String()
    
    var restaurantID:String?
    
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x:0, y: 0, width: 100, height: 100), type: NVActivityIndicatorType.BallClipRotateMultiple, color: UIColor.whiteColor(), size: CGSize(width: 100, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.MKColor.Pink
        //println(pickedMenu)
        queryParseMethod()
        configBackButton()
        createActivityIndicatorView()
        addReloadButton()
        // Do any additional setup after loading the view.
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
    
    func backButtonClick(button:UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Define the query that will provide the data for the table view
    func queryParseMethod() {
        print("Start query")
        activityIndicatorView.startAnimation()
        activityIndicatorView.hidden = false
        arrayObject.removeAll(keepCapacity: false)
        let defaults = NSUserDefaults.standardUserDefaults()
        let storedLiked = defaults.objectForKey("likedArray\(self.restaurantID)") as? [String] ?? nil
        if let _ = storedLiked {
            var query = PFQuery(className: "Product")
            if pickedMenu == "food.png" {
                query = query.whereKey("ProductKind", equalTo: "Food")
            } else {
                query = query.whereKey("ProductKind", equalTo: "Drink")
            }
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if error == nil {
                    // The find succeeded.
                    print("Successfully retrieved \(objects!.count) products.")
                    self.allArrayObject = NSMutableArray(array: objects!)
                    //println(self.allArrayObject.count)
                    for var i=0; i < self.allArrayObject.count; i++ {
                        let objectProduct:PFObject = self.allArrayObject.objectAtIndex(i) as! PFObject
                        if let _ = (storedLiked!).indexOf((objectProduct.objectId!)) {
                            //Found liked product
                            //println(objectProduct.objectId)
                            //println(storedLiked![i])
                            self.likedArrayObject.append(objectProduct)
                        }
                    }
                    if self.likedArrayObject.count == 0 {
                        // Not first time run app but there's no like / dislike all
                        let missAlertViewController:NYAlertViewController = NYAlertViewController()
                        missAlertViewController.addAction(NYAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }))
                        missAlertViewController.title = "Empty"
                        missAlertViewController.message = "You didn't like any food/drink. Please come back to menu then touch like Button if you like it. Then you can see it again here."
                        missAlertViewController.titleColor = UIColor.MKColor.Orange
                        self.presentViewController(missAlertViewController, animated: true, completion: nil)
                    } else {
                        self.loadImageToSwipableView()
                        self.swipeableView.loadViews()
                    }
                    self.activityIndicatorView.stopAnimation()
                    self.activityIndicatorView.hidden = true
                    //println(self.likedArrayObject.count)
                }
            })
        } else {
            // First time run app
            self.activityIndicatorView.stopAnimation()
            self.activityIndicatorView.hidden = true
            let missAlertViewController:NYAlertViewController = NYAlertViewController()
            missAlertViewController.addAction(NYAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            missAlertViewController.title = "Empty"
            missAlertViewController.message = "You didn't like any food/drink. Please come back to menu then touch like Button if you like it. Then you can see it again here."
            missAlertViewController.titleColor = UIColor.MKColor.Orange
            self.presentViewController(missAlertViewController, animated: true, completion: nil)
        }
    }
    
    func createActivityIndicatorView() {
        activityIndicatorView.center = self.view.center
        self.view.addSubview(activityIndicatorView)
    }
    
    func loadImageToSwipableView() {
        swipeableView = ZLSwipeableView()
        view.addSubview(swipeableView)
        swipeableView.didStart = {view, location in
            print("Did start swiping view at location: \(location)")
        }
        swipeableView.swiping = {view, location, translation in
            print("Swiping at view location: \(location) translation: \(translation)")
        }
        swipeableView.didEnd = {view, location in
            print("Did end swiping view at location: \(location)")
        }
        swipeableView.didSwipe = {view, direction, vector in
            print("Did swipe view in direction: \(direction), vector: \(vector)")
        }
        swipeableView.didCancel = {view in
            print("Did cancel swiping view")
        }
        self.swipeableView.discardViews()
        swipeableView.loadViews()
        self.swipeableView.nextView = {
            if self.productIndex < self.likedArrayObject.count {
                let cardView = CardView(frame: self.swipeableView.bounds)
                cardView.delegate = self
                cardView.likeButton.setImage(UIImage(named: "disheart.png"), forState: UIControlState.Normal)
                let productObject:PFObject = self.likedArrayObject[self.productIndex] as PFObject
                cardView.assignProductObject(productObject)
                let productName = productObject["ProductName"] as! String
                let productPrice = productObject["ProductPrice"] as! String
                cardView.getNameProduct("\(productName) - \(productPrice)")
                let imageFile:PFFile = productObject["ProductImage"] as! PFFile
                imageFile.getDataInBackgroundWithBlock({(data, error) in
                    if error == nil {
                        cardView.setImage(data!, width: self.swipeableView.bounds.width, height: self.swipeableView.bounds.height)
                        cardView.backgroundColor = self.colorForName(self.colors[self.colorIndex])
                        if self.colorIndex == self.colors.count-1 {
                            self.colorIndex = 0
                        } else {
                            self.colorIndex++
                        }
                    }
                })
                self.productIndex++
                
                return cardView
            }
            return nil
        }
        
        layout(self.swipeableView, view2: self.view) { view1, view2 in
            view1.left == view2.left + 50
            view1.right == view2.right - 50
            view1.top == view2.top + 120
            view1.bottom == view2.bottom - 100
        }
    }
    
    func addReloadButton() {
        reloadButton.frame = CGRect(x: backButton.frame.width + 5, y: 10, width: 40, height: 40)
        reloadButton.backgroundColor = UIColor.MKColor.Blue
        reloadButton.cornerRadius = 20.0
        reloadButton.backgroundLayerCornerRadius = 20.0
        reloadButton.maskEnabled = false
        reloadButton.rippleLocation = .Center
        reloadButton.ripplePercent = 1.75
        reloadButton.layer.shadowOpacity = 0.75
        reloadButton.layer.shadowRadius = 3.5
        reloadButton.layer.shadowColor = UIColor.blackColor().CGColor
        reloadButton.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        reloadButton.setImage(UIImage(named: "reload.png"), forState: UIControlState.Normal)
        reloadButton.addTarget(self, action: "reloadButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(reloadButton)
        self.view.bringSubviewToFront(reloadButton)
    }
    
    func reloadButtonClick(button:UIButton) {
        self.loadCardsFromXib = false
        self.colorIndex = 0
        self.productIndex = 0
        if self.swipeableView != nil {
            self.swipeableView.discardViews()
            self.swipeableView.loadViews()
        }
    }
    
    // MARK: ()
    func colorForName(name: String) -> UIColor {
        let sanitizedName = name.stringByReplacingOccurrencesOfString(" ", withString: "")
        let selector = "flat\(sanitizedName)Color"
        return UIColor.swift_performSelector(Selector(selector), withObject: nil) as! UIColor
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "DetailLikeProductSegue"){
            let detailDrinkView:DetailProductViewController = segue.destinationViewController as! DetailProductViewController
            detailDrinkView.productObject = sender as! PFObject
        }
    }
    
    // MARK: Card View Delegate
    func infoButtonClickProtocol(productObject: PFObject) {
        print("Touch")
        self.performSegueWithIdentifier("DetailLikeProductSegue", sender: productObject)
    }
    
    func likeButtonClickProtocol(productObject: PFObject, likeButton: MKButton) {
        print("Dislike")
        // Store liked food/drink
        let defaults = NSUserDefaults.standardUserDefaults()
        var storedLiked = defaults.objectForKey("likedArray\(self.restaurantID)") as? [String] ?? [String]()
        let objectID = productObject.objectId
        //println(storedLiked)
        
        if let isHavingLiked = storedLiked.indexOf((objectID!)) {
            //TODO: Fix this
            //If having, remove
            for var i=0; i<self.likedArrayObject.count; i++ {
                let object = self.likedArrayObject[i]
                if object.objectId == storedLiked[isHavingLiked] {
                    self.likedArrayObject.removeAtIndex(i)
                }
            }
            storedLiked.removeAtIndex(isHavingLiked)
        }
        // then update whats in the `NSUserDefault`
        defaults.setObject(storedLiked, forKey: "likedArray\(self.restaurantID)")
        
        // call this after you update
        defaults.synchronize()
        
        self.swipeableView.swipeTopView(inDirection: .Left)
        //self.swipeableView.loadViews()
        //println(storedLiked)
    }

}
