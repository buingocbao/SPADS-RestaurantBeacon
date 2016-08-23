//
//  SwiftCardViewController.swift
//  SPADS-RestaurantBeacon
//
//  Created by BBaoBao on 8/8/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit
import performSelector_swift
import UIColor_FlatColors
import Cartography
import ReactiveUI
import ZLSwipeableViewSwift
import AsyncDisplayKit

class SwiftCardViewController: UIViewController , UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, CardViewProtocol, UIViewControllerTransitioningDelegate  {
    
    var swipeableView: ZLSwipeableView!
    var pickedMenu:String = String()
    var backButton:MKButton = MKButton()
    var reloadButton:MKButton = MKButton()
    var reloadLikedButton:MKButton = MKButton()
    var collectionView: UICollectionView!
    let nodeConstructionQueue = NSOperationQueue()
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x:0, y: 0, width: 100, height: 100), type: NVActivityIndicatorType.BallClipRotateMultiple, color: UIColor.whiteColor(), size: CGSize(width: 100, height: 100))
    
    let transition = BubbleTransition()
    var touchButton:String = ""
    
    var productsFileArray: NSArray = NSArray()
    
    var restaurantID:String?
    
    var colors = ["Turquoise", "Green Sea", "Emerald", "Nephritis", "Peter River", "Belize Hole", "Amethyst", "Wisteria", "Wet Asphalt", "Midnight Blue", "Sun Flower", "Orange", "Carrot", "Pumpkin", "Alizarin", "Pomegranate", "Clouds", "Silver", "Concrete", "Asbestos"]
    var colorIndex = 0
    var productIndex = 0
    var loadCardsFromXib = false
    
    //var reloadBarButtonItem = UIBarButtonItem(title: "Reload", style: .Plain) { item in }
    //var leftBarButtonItem = UIBarButtonItem(title: "←", style: .Plain) { item in }
    //var upBarButtonItem = UIBarButtonItem(title: "↑", style: .Plain) { item in }
    //var rightBarButtonItem = UIBarButtonItem(title: "→", style: .Plain) { item in }
    //var downBarButtonItem = UIBarButtonItem(title: "↓", style: .Plain) { item in }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //swipeableView.loadViews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        createBackgroundView()
        queryParseMethod()
        transparentNavigationBar()
        addLeftNavItemOnView()
        addReloadButton()
        createThumbnailMenu()
        createActivityIndicatorView()
        //navigationController?.setToolbarHidden(false, animated: false)
        //view.backgroundColor = UIColor.whiteColor()
        view.clipsToBounds = true
        self.view.backgroundColor = UIColor.grayColor()
    }
    
    func createBackgroundView() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = self.view.bounds
        self.view.addSubview(blurEffectView)
        self.view.sendSubviewToBack(blurEffectView)
        
        let backgroundView = UIImageView(frame: self.view.bounds)
        backgroundView.image = UIImage(named: "SwiftCardBK")
        self.view.addSubview(backgroundView)
        self.view.sendSubviewToBack(backgroundView)
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
            if vector.dx > 0 {
                print("Right")
            } else {
                print("Left")
            }
        }
        swipeableView.didCancel = {view in
            print("Did cancel swiping view")
        }
        self.swipeableView.discardViews()
        swipeableView.loadViews()
        self.swipeableView.nextView = {
            if self.productIndex < self.productsFileArray.count {
                let cardView = CardView(frame: self.swipeableView.bounds)
                cardView.delegate = self
                cardView.initImage(UIImage(named: self.pickedMenu)!, width: self.swipeableView.bounds.width, height: self.swipeableView.bounds.height)
                let productObject:PFObject = self.productsFileArray.objectAtIndex(self.productIndex) as! PFObject
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
    
    // Define the query that will provide the data for the table view
    func queryParseMethod() {
        print("Start query")
        activityIndicatorView.startAnimation()
        activityIndicatorView.hidden = false
        var query = PFQuery(className: "Product").whereKey("Restaurant", equalTo: self.restaurantID!)
        if pickedMenu == "food.png" {
            query = query.whereKey("ProductKind", equalTo: "Food")
        } else {
            query = query.whereKey("ProductKind", equalTo: "Drink")
        }
        query.orderByAscending("ProductID")
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) products.")
                self.productsFileArray = objects!
                print(self.productsFileArray)
            } else {
                self.showAlertForConnection()
            }
            self.activityIndicatorView.stopAnimation()
            self.activityIndicatorView.hidden = true
            self.collectionView.reloadData()
            self.loadImageToSwipableView()
            self.swipeableView.loadViews()
        }
    }
    
    func transparentNavigationBar() {
        // Transparent navigation bar
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        
        bar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor.clearColor()
    }
    
    // MARK: ()
    func colorForName(name: String) -> UIColor {
        let sanitizedName = name.stringByReplacingOccurrencesOfString(" ", withString: "")
        let selector = "flat\(sanitizedName)Color"
        return UIColor.swift_performSelector(Selector(selector), withObject: nil) as! UIColor
    }
    
    func addLeftNavItemOnView (){
        // hide default navigation bar button item
        self.navigationItem.backBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = true;
        
        backButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
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
        backButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 20)
        backButton.addTarget(self, action: "backButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)

        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: false)

        self.navigationItem.title = ""
    }
    
    func addReloadButton() {
        reloadButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
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
        let rightBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: reloadButton)
        //self.navigationItem.setRightBarButtonItem(rightBarButtonItem, animated: false)
        
        reloadLikedButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        reloadLikedButton.backgroundColor = UIColor.whiteColor()
        reloadLikedButton.cornerRadius = 20.0
        reloadLikedButton.backgroundLayerCornerRadius = 20.0
        reloadLikedButton.maskEnabled = false
        reloadLikedButton.rippleLocation = .Center
        reloadLikedButton.ripplePercent = 1.75
        reloadLikedButton.layer.shadowOpacity = 0.75
        reloadLikedButton.layer.shadowRadius = 3.5
        reloadLikedButton.layer.shadowColor = UIColor.blackColor().CGColor
        reloadLikedButton.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        reloadLikedButton.setImage(UIImage(named: "pinkHeart.png"), forState: UIControlState.Normal)
        reloadLikedButton.addTarget(self, action: "reloadLikedButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        let rightBarLikedButtonItem: UIBarButtonItem = UIBarButtonItem(customView: reloadLikedButton)
        self.navigationItem.setRightBarButtonItems([rightBarButtonItem,rightBarLikedButtonItem], animated: false)
    }

    func backButtonClick(button:UIButton) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
    }
    
    func reloadButtonClick(button:UIButton) {
        self.loadCardsFromXib = false
        self.colorIndex = 0
        self.productIndex = 0
        if self.swipeableView != nil {
            self.swipeableView.discardViews()
            //self.createSwipableView()
            //self.loadImageToSwipableView()
            self.swipeableView.loadViews()
        }
    }
    
    func reloadLikedButtonClick(button: UIButton) {
        touchButton = "LikeButton"
        self.performSegueWithIdentifier("LikedSwiftCardSegue", sender: nil)
    }
    
    func createThumbnailMenu() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: self.view.frame.height-100, width: self.view.frame.width, height: 120), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(ThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        self.view.bringSubviewToFront(collectionView)
    }
    
    func createActivityIndicatorView() {
        activityIndicatorView.center = self.view.center
        self.view.addSubview(activityIndicatorView)
    }
    
    func showAlertForConnection() {
        let alertVC:NYAlertViewController = NYAlertViewController(nibName: nil, bundle: nil)
        alertVC.backgroundTapDismissalGestureEnabled = false
        alertVC.swipeDismissalGestureEnabled = true
        alertVC.title = "Connection Lost"
        alertVC.message = "It seems like your device don't connect to any network. Please try later!"
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
        alertVC.buttonColor = UIColor.MKColor.Red
        alertVC.buttonTitleColor = UIColor(white: 0.19, alpha: 1.0)
        alertVC.cancelButtonColor = UIColor.MKColor.Red
        alertVC.cancelButtonTitleColor = UIColor(white: 0.19, alpha: 1.0)
        alertVC.addAction(NYAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            //OK action
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alertVC, animated: true, completion: nil)
    }
    
    // MARK: Thumbnail collection view data source 
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productsFileArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : ThumbnailCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ThumbnailCollectionViewCell
        
        // Configure the cell
        let productObject:PFObject = productsFileArray.objectAtIndex(indexPath.row) as! PFObject
        let imageFile:PFFile = productObject["ProductImage"] as! PFFile
        // Set init image if drink image in cell doesn't load.
        //var initImage = UIImage(named: "DefaultProduct.png")
        
        //cell.featureImageSizeOptional = initImage?.size
        imageFile.getDataInBackgroundWithBlock({(data, error) in
            if error == nil {
                cell.configureCellDisplayWithDrinkInfo(productObject, data: data!, nodeConstructionQueue: self.nodeConstructionQueue)
            }
        })
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let productObject:PFObject = productsFileArray.objectAtIndex(indexPath.row) as! PFObject
        self.performSegueWithIdentifier("DetailProductSegue", sender: productObject)
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }

    // MARK: Prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "DetailProductSegue"){
            let detailDrinkView:DetailProductViewController = segue.destinationViewController as! DetailProductViewController
            detailDrinkView.productObject = sender as! PFObject
        }
        
        if (segue.identifier == "LikedSwiftCardSegue"){
            /*
            if let controller = segue.destinationViewController as? UIViewController {
                controller.transitioningDelegate = self
                controller.modalPresentationStyle = .Custom
            }*/
            let controller = segue.destinationViewController
            controller.transitioningDelegate = self
            controller.modalPresentationStyle = .Custom
            let likedView:LikedSwiftCardViewController = segue.destinationViewController as! LikedSwiftCardViewController
            likedView.pickedMenu = pickedMenu
            likedView.restaurantID = self.restaurantID
        }
    }
    
    // MARK: Card View Delegate
    func infoButtonClickProtocol(productObject: PFObject) {
        print("Touch")
        self.performSegueWithIdentifier("DetailProductSegue", sender: productObject)
    }
    
    func likeButtonClickProtocol(productObject: PFObject, likeButton: MKButton) {
        print("Like")
        // Store liked food/drink
        let defaults = NSUserDefaults.standardUserDefaults()
        var storedLiked = defaults.objectForKey("likedArray\(self.restaurantID)") as? [String] ?? [String]()
        let objectID = productObject.objectId
        //println(storedLiked)
        
        if let _ = storedLiked.indexOf((objectID!)) {
            //If having, do nothing
        } else {
            storedLiked.append(objectID!)
        }
        
        // then update whats in the `NSUserDefault`
        defaults.setObject(storedLiked, forKey: "likedArray\(self.restaurantID)")
        
        // call this after you update
        defaults.synchronize()
        //println(storedLiked)
        
        self.swipeableView.swipeTopView(inDirection: .Right)
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Present
        switch touchButton {
        case "LikeButton":
            //
            transition.startingPoint = reloadLikedButton.center
            transition.bubbleColor = UIColor.MKColor.Pink
        default:
            break
        }
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Dismiss
        switch touchButton {
        case "LikeButton":
            transition.startingPoint = reloadLikedButton.center
            transition.bubbleColor = UIColor.MKColor.Pink
        default:
            break
        }
        return transition
    }
}
