//
//  QueryProductViewController.swift
//  SPADS-RestaurantBeacon
//
//  Created by BBaoBao on 8/16/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class QueryProductViewController: PFQueryCollectionViewController {
    
    var cellMargin:CGFloat = 10.0
    var cellSpacing:CGFloat = 10.0
    var cellTextAreaHeight:CGFloat = 40.0
    var selectedCell:QueryProductViewCell?
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x:0, y: 0, width: 100, height: 100), type: NVActivityIndicatorType.BallClipRotateMultiple, color: UIColor.whiteColor(), size: CGSize(width: 100, height: 100))
    
    override init(collectionViewLayout layout: UICollectionViewLayout, className: String?) {
        super.init(collectionViewLayout: layout, className: className)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Configure the PFQueryTableView
        self.parseClassName = "Product"
        self.loadingViewEnabled = false
        self.paginationEnabled = false
        //self.objectsPerPage = 20
    }
    
    override func objectsWillLoad() {
        collectionView?.backgroundColor = UIColor.MKColor.Teal
        // Show activityIndicatior
        self.activityIndicatorView.center = self.view.center
        self.view.addSubview(activityIndicatorView)
        self.view.bringSubviewToFront(activityIndicatorView)
        self.activityIndicatorView.startAnimation()
    }
    
    override func objectsDidLoad(error: NSError?) {
        self.activityIndicatorView.stopAnimation()
        self.activityIndicatorView.hidden = true
    }
    
    override func queryForCollection() -> PFQuery {
        var restaurantID = ""
        if let restaurant = PFUser.currentUser()!["Restaurant"] as? String {
            restaurantID = restaurant
        }
        let query = PFQuery(className: "Product").whereKey("Restaurant", equalTo: restaurantID)
        query.orderByDescending("ProductKind").orderByAscending("ProductName")
        return query
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // MARK: Collection View Delegate & Flow layout
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFCollectionViewCell? {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ProductQueryCell", forIndexPath: indexPath) as! QueryProductViewCell
        
        if let productImage = object?["ProductImage"] as? PFFile {
            cell.productImage.file = productImage
            cell.productImage.loadInBackground()
        }
        
        if let productName = object?["ProductName"] as? String {
            cell.productName.text = productName
        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: false)
        let passObject:PFObject = self.objects[indexPath.row] as! PFObject
        self.performSegueWithIdentifier("EditProductSegue", sender: passObject)
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width:CGFloat = self.collectionView!.frame.size.width/2 - cellMargin - (cellSpacing/2)
        return CGSizeMake(width, width + cellTextAreaHeight)
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(cellMargin, cellMargin, cellMargin, cellMargin)
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return cellSpacing
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return cellSpacing
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "EditProductSegue") {
            let addProductView:AddProductViewController = segue.destinationViewController as! AddProductViewController
            addProductView.lbMainText = "Edit Product"
            addProductView.currentObject = sender as? PFObject
        }
    }
 }
