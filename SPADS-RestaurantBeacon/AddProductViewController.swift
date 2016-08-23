//
//  AddProductViewController.swift
//  SPADS-RestaurantBeacon
//
//  Created by BBaoBao on 8/16/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos

class AddProductViewController: UIViewController, UITextFieldDelegate {

    var backButton: MKButton = MKButton()
    var scrollView: UIScrollView!
    var lbMainText: String = String()
    var currentObject: PFObject?
    var commitButton: MKButton = MKButton()
    var isCheckedForCommit = false
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x:0, y: 0, width: 100, height: 100), type: NVActivityIndicatorType.BallClipRotateMultiple, color: UIColor.whiteColor(), size: CGSize(width: 100, height: 100))
    
    // Labels
    var lbMain: UILabel!
    var lbProductName: UILabel!
    var lbProductDes: UILabel!
    var lbProductImage: UILabel!
    var lbProductPrice:UILabel!
    var lbProductKind:UILabel!
    
    // Text Field
    var tfProductName: MKTextField!
    var tfProductDes: MKTextField!
    var tfProductPrice: MKTextField!
    var tfProductKind: MKTextField!
    
    // Buttons
    var btImageLink: MKButton!
    var btImageUpload: MKButton!
    
    // Image View
    var productImage: UIImageView!
    var productImageFromParse: PFImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configBackButton()
        configScrollView()
        configViews()
        configActivity()
        //println(currentObject)
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
    
    func configScrollView(){
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.contentSize = CGSize(width: view.bounds.width, height: 1200)
        scrollView.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        self.scrollView.directionalLockEnabled = true
        scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.Interactive
        view.addSubview(scrollView)
        self.view.sendSubviewToBack(scrollView)
    }
    
    func configActivity() {
        self.activityIndicatorView.center = self.view.center
        self.view.addSubview(activityIndicatorView)
        self.view.bringSubviewToFront(activityIndicatorView)
        self.activityIndicatorView.hidden = true
    }
    
    func configViews(){
        // 1.Main Label
        lbMain = UILabel(frame: CGRect(x: 0, y: 5, width: self.view.frame.width, height: 30))
        lbMain.font = UIFont(name: "AvenirNext-Regular", size: 30)
        lbMain.textColor = UIColor.whiteColor()
        lbMain.textAlignment = .Center
        lbMain.text = lbMainText
        self.scrollView.addSubview(lbMain)
        view.addConstraint(NSLayoutConstraint(item:lbMain, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.scrollView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        
        // 2.Promotion Name Label
        lbProductName = UILabel(frame: CGRect(x: 5, y: 0, width: self.view.frame.width/2, height: 20))
        lbProductName.font = UIFont(name: "AvenirNext-Regular", size: 20)
        lbProductName.textColor = UIColor.whiteColor()
        lbProductName.textAlignment = .Left
        lbProductName.text = "Product Name"
        self.scrollView.addSubview(lbProductName)
        lbProductName.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintLBName = NSLayoutConstraint(item: lbProductName, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:lbMain, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 20)
        let leftConstraintLBName = NSLayoutConstraint(item: lbProductName, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:scrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
        view.addConstraints([topConstraintLBName,leftConstraintLBName])
        
        // 3.Promotion Name TextField
        tfProductName = MKTextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: 100))
        tfProductName.layer.borderColor = UIColor.clearColor().CGColor
        tfProductName.floatingPlaceholderEnabled = true
        tfProductName.placeholder = "Name"
        tfProductName.tintColor = UIColor.whiteColor()
        tfProductName.textColor = UIColor.whiteColor()
        tfProductName.rippleLocation = .Right
        tfProductName.cornerRadius = 0
        tfProductName.bottomBorderEnabled = true
        tfProductName.borderStyle = UITextBorderStyle.None
        tfProductName.minimumFontSize = 17
        tfProductName.font = UIFont(name: "HelveticaNeue", size: 20)
        tfProductName.clearButtonMode = UITextFieldViewMode.UnlessEditing
        tfProductName.delegate = self
        self.scrollView.addSubview(tfProductName)
        tfProductName.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintTFName = NSLayoutConstraint(item: tfProductName, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:lbProductName, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 5)
        let leftConstraintTFName = NSLayoutConstraint(item: tfProductName, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:scrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
        let widthConstraintTFName = NSLayoutConstraint(item: tfProductName, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width/2)
        let heightConstraintTFName = NSLayoutConstraint(item: tfProductName, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
        view.addConstraints([topConstraintTFName,leftConstraintTFName, widthConstraintTFName, heightConstraintTFName])
        
        if let object = currentObject {
            tfProductName.text = object["ProductName"] as? String
        }
        
        
        // 4.Promotion Description Label
        lbProductDes = UILabel(frame: CGRect(x: 5, y: 0, width: self.view.frame.width/2, height: 20))
        lbProductDes.font = UIFont(name: "AvenirNext-Regular", size: 20)
        lbProductDes.textColor = UIColor.whiteColor()
        lbProductDes.textAlignment = .Left
        lbProductDes.text = "Product Description"
        self.scrollView.addSubview(lbProductDes)
        lbProductDes.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintLBDes = NSLayoutConstraint(item: lbProductDes, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:tfProductName, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 10)
        let leftConstraintLBDes = NSLayoutConstraint(item: lbProductDes, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:scrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
        view.addConstraints([topConstraintLBDes,leftConstraintLBDes])
        
        // 5.Promotion Description TextField
        tfProductDes = MKTextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: 50))
        tfProductDes.layer.borderColor = UIColor.clearColor().CGColor
        tfProductDes.floatingPlaceholderEnabled = true
        tfProductDes.placeholder = "Description"
        tfProductDes.tintColor = UIColor.whiteColor()
        tfProductDes.textColor = UIColor.whiteColor()
        tfProductDes.rippleLocation = .Right
        tfProductDes.cornerRadius = 0
        tfProductDes.bottomBorderEnabled = true
        tfProductDes.borderStyle = UITextBorderStyle.None
        tfProductDes.minimumFontSize = 17
        tfProductDes.font = UIFont(name: "HelveticaNeue", size: 20)
        tfProductDes.clearButtonMode = UITextFieldViewMode.UnlessEditing
        tfProductDes.delegate = self
        self.scrollView.addSubview(tfProductDes)
        tfProductDes.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintTFDes = NSLayoutConstraint(item: tfProductDes, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:lbProductDes, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 5)
        let leftConstraintTFDes = NSLayoutConstraint(item: tfProductDes, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:scrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
        let widthConstraintTFDes = NSLayoutConstraint(item: tfProductDes, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width-20)
        let heightConstraintTFDes = NSLayoutConstraint(item: tfProductDes, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
        view.addConstraints([topConstraintTFDes,leftConstraintTFDes, widthConstraintTFDes, heightConstraintTFDes])
        
        if let object = currentObject {
            tfProductDes.text = object["ProductDescription"] as? String
        }
        
        // 6.Promotion Image Label
        lbProductImage = UILabel(frame: CGRect(x: 5, y: 0, width: self.view.frame.width/2, height: 20))
        lbProductImage.font = UIFont(name: "AvenirNext-Regular", size: 20)
        lbProductImage.textColor = UIColor.whiteColor()
        lbProductImage.textAlignment = .Left
        lbProductImage.text = "Product Image"
        self.scrollView.addSubview(lbProductImage)
        lbProductImage.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintLBImage = NSLayoutConstraint(item: lbProductImage, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:tfProductDes, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 10)
        let leftConstraintLBImage = NSLayoutConstraint(item: lbProductImage, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:scrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
        view.addConstraints([topConstraintLBImage,leftConstraintLBImage])
        
        // 7.Promotion Image Add Link Button
        btImageLink = MKButton(frame: CGRect(x: 5, y: 0, width: self.view.frame.width/2-10, height: 50))
        btImageLink.layer.shadowOpacity = 0.55
        btImageLink.layer.shadowRadius = 5.0
        btImageLink.layer.shadowColor = UIColor.blackColor().CGColor
        btImageLink.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        btImageLink.backgroundColor = UIColor.MKColor.Green
        btImageLink.setTitle("Add Link", forState: UIControlState.Normal)
        btImageLink.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btImageLink.addTarget(self, action: "imageLinkButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.scrollView.addSubview(btImageLink)
        btImageLink.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintBTImageAdd = NSLayoutConstraint(item: btImageLink, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:lbProductImage, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 10)
        let leftConstraintBTImageAdd = NSLayoutConstraint(item: btImageLink, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:scrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
        let widthConstraintBTImageAdd = NSLayoutConstraint(item: btImageLink, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width/2-20)
        let heightConstraintBTImageAdd = NSLayoutConstraint(item: btImageLink, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
        view.addConstraints([topConstraintBTImageAdd,leftConstraintBTImageAdd, widthConstraintBTImageAdd, heightConstraintBTImageAdd])
        
        // 8.Promotion Image Upload Button
        btImageUpload = MKButton(frame: CGRect(x: 5, y: 0, width: self.view.frame.width/2-10, height: 50))
        btImageUpload.layer.shadowOpacity = 0.55
        btImageUpload.layer.shadowRadius = 5.0
        btImageUpload.layer.shadowColor = UIColor.blackColor().CGColor
        btImageUpload.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        btImageUpload.backgroundColor = UIColor.MKColor.Green
        btImageUpload.setTitle("Upload", forState: UIControlState.Normal)
        btImageUpload.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btImageUpload.addTarget(self, action: "imageUploadButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.scrollView.addSubview(btImageUpload)
        btImageUpload.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintBTImageUpload = NSLayoutConstraint(item: btImageUpload, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:lbProductImage, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 10)
        let leftConstraintBTImageUpload = NSLayoutConstraint(item: btImageUpload, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:btImageLink, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
        let widthConstraintBTImageUpload = NSLayoutConstraint(item: btImageUpload, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width/2-20)
        let heightConstraintBTImageUpload = NSLayoutConstraint(item: btImageUpload, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
        view.addConstraints([topConstraintBTImageUpload,leftConstraintBTImageUpload, widthConstraintBTImageUpload, heightConstraintBTImageUpload])
        
        // 9.Promotion UIImageView
        if let object = currentObject {
            productImageFromParse = PFImageView(frame: CGRect(x: 5, y: 0, width: self.view.frame.width-20, height: 50))
            productImageFromParse.image = UIImage(named: "food.png")
            productImageFromParse.contentMode = UIViewContentMode.ScaleAspectFit
            self.scrollView.addSubview(productImageFromParse)
            productImageFromParse.translatesAutoresizingMaskIntoConstraints = false
            let topConstraintImage = NSLayoutConstraint(item: productImageFromParse, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: btImageLink, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 10)
            let leftConstraintImage = NSLayoutConstraint(item: productImageFromParse, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: scrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
            let widthConstraintImage = NSLayoutConstraint(item: productImageFromParse, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width-20)
            let heightConstraintImage = NSLayoutConstraint(item: productImageFromParse, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.height/2)
            view.addConstraints([topConstraintImage, leftConstraintImage, widthConstraintImage, heightConstraintImage])
            
            productImageFromParse.file = object["ProductImage"] as? PFFile
        } else {
            productImage = UIImageView(frame: CGRect(x: 5, y: 0, width: self.view.frame.width-20, height: 50))
            productImage.image = UIImage(named: "food.png")
            productImage.contentMode = UIViewContentMode.ScaleAspectFit
            self.scrollView.addSubview(productImage)
            productImage.translatesAutoresizingMaskIntoConstraints = false
            let topConstraintImage = NSLayoutConstraint(item: productImage, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: btImageLink, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 10)
            let leftConstraintImage = NSLayoutConstraint(item: productImage, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: scrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
            let widthConstraintImage = NSLayoutConstraint(item: productImage, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width-20)
            let heightConstraintImage = NSLayoutConstraint(item: productImage, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.height/2)
            view.addConstraints([topConstraintImage, leftConstraintImage, widthConstraintImage, heightConstraintImage])
        }
        
        // 10.Product Price Label
        lbProductPrice = UILabel(frame: CGRect(x: 5, y: 0, width: self.view.frame.width/2, height: 20))
        lbProductPrice.font = UIFont(name: "AvenirNext-Regular", size: 20)
        lbProductPrice.textColor = UIColor.whiteColor()
        lbProductPrice.textAlignment = .Left
        lbProductPrice.text = "Product Price"
        self.scrollView.addSubview(lbProductPrice)
        lbProductPrice.translatesAutoresizingMaskIntoConstraints = false
        var topConstraintLBPrice = NSLayoutConstraint()
        if let _ = currentObject {
            topConstraintLBPrice = NSLayoutConstraint(item: lbProductPrice, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:productImageFromParse, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 20)
        } else {
            topConstraintLBPrice = NSLayoutConstraint(item: lbProductPrice, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:productImage, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 20)
        }
        let leftConstraintLBPrice = NSLayoutConstraint(item: lbProductPrice, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:scrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
        let widthConstraintLBPrice = NSLayoutConstraint(item: lbProductPrice, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width/2-20)
        view.addConstraints([topConstraintLBPrice,leftConstraintLBPrice, widthConstraintLBPrice])

        // 11.Product Price TextField
        tfProductPrice = MKTextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: 100))
        tfProductPrice.layer.borderColor = UIColor.clearColor().CGColor
        tfProductPrice.floatingPlaceholderEnabled = true
        tfProductPrice.placeholder = "Price"
        tfProductPrice.tintColor = UIColor.whiteColor()
        tfProductPrice.textColor = UIColor.whiteColor()
        tfProductPrice.rippleLocation = .Right
        tfProductPrice.cornerRadius = 0
        tfProductPrice.bottomBorderEnabled = true
        tfProductPrice.borderStyle = UITextBorderStyle.None
        tfProductPrice.minimumFontSize = 17
        tfProductPrice.font = UIFont(name: "HelveticaNeue", size: 20)
        tfProductPrice.clearButtonMode = UITextFieldViewMode.UnlessEditing
        tfProductPrice.delegate = self
        self.scrollView.addSubview(tfProductPrice)
        tfProductPrice.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintTFPrice = NSLayoutConstraint(item: tfProductPrice, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:lbProductPrice, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 5)
        let leftConstraintTFPrice = NSLayoutConstraint(item: tfProductPrice, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:scrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
        let widthConstraintTFPrice = NSLayoutConstraint(item: tfProductPrice, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width/2-20)
        let heightConstraintTFPrice = NSLayoutConstraint(item: tfProductPrice, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
        view.addConstraints([topConstraintTFPrice,leftConstraintTFPrice, widthConstraintTFPrice, heightConstraintTFPrice])
        
        if let object = currentObject {
            tfProductPrice.text = object["ProductPrice"] as? String
        }

        // 12.Promotion Kind Label
        lbProductKind = UILabel(frame: CGRect(x: 5, y: 0, width: self.view.frame.width/2, height: 20))
        lbProductKind.font = UIFont(name: "AvenirNext-Regular", size: 20)
        lbProductKind.textColor = UIColor.whiteColor()
        lbProductKind.textAlignment = .Left
        lbProductKind.text = "Product Kind"
        self.scrollView.addSubview(lbProductKind)
        lbProductKind.translatesAutoresizingMaskIntoConstraints = false
        var topConstraintLBKind = NSLayoutConstraint()
        if let _ = currentObject {
            topConstraintLBKind = NSLayoutConstraint(item: lbProductKind, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: productImageFromParse, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 20)
        } else {
            topConstraintLBKind = NSLayoutConstraint(item: lbProductKind, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: productImage, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 20)
        }
        let leftConstraintLBKind = NSLayoutConstraint(item: lbProductKind, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: lbProductPrice, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 20)
        view.addConstraints([topConstraintLBKind,leftConstraintLBKind])

        // 13.Promotion Kind Textfield
        tfProductKind = MKTextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: 100))
        tfProductKind.layer.borderColor = UIColor.clearColor().CGColor
        tfProductKind.floatingPlaceholderEnabled = true
        tfProductKind.placeholder = "Kind"
        tfProductKind.tintColor = UIColor.whiteColor()
        tfProductKind.textColor = UIColor.whiteColor()
        tfProductKind.rippleLocation = .Right
        tfProductKind.cornerRadius = 0
        tfProductKind.bottomBorderEnabled = true
        tfProductKind.borderStyle = UITextBorderStyle.None
        tfProductKind.minimumFontSize = 17
        tfProductKind.font = UIFont(name: "HelveticaNeue", size: 20)
        tfProductKind.clearButtonMode = UITextFieldViewMode.UnlessEditing
        tfProductKind.delegate = self
        self.scrollView.addSubview(tfProductKind)
        tfProductKind.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintTFKind = NSLayoutConstraint(item: tfProductKind, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:lbProductPrice, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 5)
        let leftConstraintTFKind = NSLayoutConstraint(item: tfProductKind, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:tfProductPrice, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
        let widthConstraintTFKind = NSLayoutConstraint(item: tfProductKind, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width/2-20)
        let heightConstraintTFKind = NSLayoutConstraint(item: tfProductKind, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
        view.addConstraints([topConstraintTFKind,leftConstraintTFKind, widthConstraintTFKind, heightConstraintTFKind])
        
        if let object = currentObject {
            tfProductKind.text = object["ProductKind"] as? String
        }
        
        // MARK: ...
        
        // 16.Promotion Commit Button
        commitButton = MKButton(frame: CGRect(x: 5, y: 0, width: self.view.frame.width/2-10, height: 50))
        commitButton.layer.shadowOpacity = 0.55
        commitButton.layer.shadowRadius = 5.0
        commitButton.layer.shadowColor = UIColor.blackColor().CGColor
        commitButton.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        commitButton.backgroundColor = UIColor.MKColor.Blue
        if let _ = currentObject {
            commitButton.setTitle("Update", forState: UIControlState.Normal)
        } else {
            commitButton.setTitle("Commit", forState: UIControlState.Normal)
        }
        commitButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        commitButton.addTarget(self, action: "commitButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.scrollView.addSubview(commitButton)
        commitButton.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintBTCommit = NSLayoutConstraint(item: commitButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:tfProductPrice, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 20)
        let leftConstraintBTCommit = NSLayoutConstraint(item: commitButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:scrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
        let widthConstraintBTCommit = NSLayoutConstraint(item: commitButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width-20)
        let heightConstraintBTCommit = NSLayoutConstraint(item: commitButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
        view.addConstraints([topConstraintBTCommit,leftConstraintBTCommit, widthConstraintBTCommit, heightConstraintBTCommit])
    }
    
    // Button Events
    func backButtonClick(button:UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imageLinkButtonClick(button: UIButton) {
        print("Image Link Button Touched")
        showAddImageLink()
    }
    
    func imageUploadButtonClick(button: UIButton) {
        print("Image Upload Button Touched")
        showPickerView()
    }
    
    func commitButtonClick(button: UIButton) {
        print("Commit Button Touched")
        if tfProductName.text == "" {
            let missAlertViewController:NYAlertViewController = NYAlertViewController()
            missAlertViewController.addAction(NYAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            missAlertViewController.title = "Missing"
            missAlertViewController.message = "Please fill Product Name!"
            missAlertViewController.titleColor = UIColor.MKColor.Orange
            self.presentViewController(missAlertViewController, animated: true, completion: nil)
        } else
            if tfProductDes.text == "" {
                let missAlertViewController:NYAlertViewController = NYAlertViewController()
                missAlertViewController.addAction(NYAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                }))
                missAlertViewController.title = "Missing"
                missAlertViewController.message = "Please fill Product Description!"
                missAlertViewController.titleColor = UIColor.MKColor.Orange
                self.presentViewController(missAlertViewController, animated: true, completion: nil)
            } else
                if tfProductPrice.text == "" {
                    let missAlertViewController:NYAlertViewController = NYAlertViewController()
                    missAlertViewController.addAction(NYAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }))
                    missAlertViewController.title = "Missing"
                    missAlertViewController.message = "Please fill Product Price!"
                    missAlertViewController.titleColor = UIColor.MKColor.Orange
                    self.presentViewController(missAlertViewController, animated: true, completion: nil)
                } else
                    if tfProductKind.text == "" {
                        let missAlertViewController:NYAlertViewController = NYAlertViewController()
                        missAlertViewController.addAction(NYAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }))
                        missAlertViewController.title = "Missing"
                        missAlertViewController.message = "Please fill Product Kind!"
                        missAlertViewController.titleColor = UIColor.MKColor.Orange
                    } else
                    {
                                //Everything's Ok
                                // Prevent user hit buttons previously
                                self.commitButton.userInteractionEnabled = false
                                // Show activityIndicatior
                                self.activityIndicatorView.hidden = false
                                self.activityIndicatorView.startAnimation()
                                
                                let date = NSDate()
                                let calendar = NSCalendar.currentCalendar()
                                let components = calendar.components([.Hour, .Minute, .Day, .Month, .Year], fromDate: date)
                                let hour = String(components.hour)
                                let minutes = String(components.minute)
                                let day = String(components.day)
                                let month = String(components.month)
                                let year = String(components.year)
                                
                                let imageName = "\(hour)-\(minutes)-\(day)-\(month)-\(year)"
                                
                                if let object = currentObject { //Edit exist object
                                    object["ProductName"] = tfProductName.text
                                    object["ProductDescription"] = tfProductDes.text
                                    object["ProductPrice"] = "\(tfProductPrice.text)"
                                    object["ProductKind"] = tfProductKind.text!.lowercaseString.capitalizedString
                                    let imageData:NSData = UIImagePNGRepresentation(self.productImageFromParse.image!)!
                                    let imageFile:PFFile = PFFile(name: "Product-\(imageName).png", data: imageData)
                                    object["ProductImage"] = imageFile
                                                                        object.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
                                        //
                                        if succeeded {
                                            // Allow user hit commit buttons
                                            self.commitButton.userInteractionEnabled = true
                                            self.activityIndicatorView.stopAnimation()
                                            self.activityIndicatorView.hidden = true
                                            let successAlertViewController:NYAlertViewController = NYAlertViewController()
                                            successAlertViewController.addAction(NYAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                                                self.dismissViewControllerAnimated(true, completion: nil)
                                            }))
                                            successAlertViewController.title = "Successful"
                                            successAlertViewController.message = "You successfully updated product!"
                                            successAlertViewController.titleColor = UIColor.MKColor.Orange
                                            successAlertViewController.buttonColor = UIColor.MKColor.Green
                                            successAlertViewController.buttonTitleColor = UIColor(white: 0.19, alpha: 1.0)
                                            self.presentViewController(successAlertViewController, animated: true, completion: nil)
                                        }
                                    })
                                } else {
                                    let object = PFObject(className: "Product")
                                    object.setObject(tfProductName.text!, forKey: "ProductName")
                                    object.setObject(tfProductDes.text!, forKey: "ProductDescription")
                                    object.setObject(tfProductPrice.text!, forKey: "ProductPrice")
                                    object.setObject(tfProductKind.text!, forKey: "ProductKind")
                                    let imageData:NSData = UIImagePNGRepresentation(self.productImage.image!)!
                                    let imageFile:PFFile = PFFile(name: "Product-\(imageName).png", data: imageData)
                                    object.setObject(imageFile, forKey: "ProductImage")
                                    object.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
                                        //
                                        if succeeded {
                                            // Allow user hit commit buttons
                                            self.commitButton.userInteractionEnabled = true
                                            self.activityIndicatorView.stopAnimation()
                                            self.activityIndicatorView.hidden = true
                                            let successAlertViewController:NYAlertViewController = NYAlertViewController()
                                            successAlertViewController.addAction(NYAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                                                self.dismissViewControllerAnimated(true, completion: nil)
                                            }))
                                            successAlertViewController.title = "Successful"
                                            successAlertViewController.message = "You successfully created new Product!"
                                            successAlertViewController.titleColor = UIColor.MKColor.Orange
                                            successAlertViewController.buttonColor = UIColor.MKColor.Green
                                            successAlertViewController.buttonTitleColor = UIColor(white: 0.19, alpha: 1.0)
                                            self.presentViewController(successAlertViewController, animated: true, completion: nil)
                                        }
                                    })
                                }
        }
        
    }
    
    func showAddImageLink() {
        let alertViewController:NYAlertViewController = NYAlertViewController()
        
        alertViewController.addAction(NYAlertAction(title: "Download", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: {
                let underAlertViewController:NYAlertViewController = NYAlertViewController()
                underAlertViewController.addAction(NYAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                }))
                underAlertViewController.title = "Under Construction"
                underAlertViewController.message = "This function is not available. Please try again on next update version"
                underAlertViewController.titleColor = UIColor.MKColor.Orange
                self.presentViewController(underAlertViewController, animated: true, completion: nil)
            })
        }))
        alertViewController.addAction(NYAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        alertViewController.title = "Add Image Link"
        alertViewController.message = "Please paste your image link here, we'll download and assign it for you"
        alertViewController.titleColor = UIColor.MKColor.Orange
        
        let tfLink:UITextField = UITextField()
        tfLink.backgroundColor = UIColor.MKColor.Green
        tfLink.textColor = UIColor.whiteColor()
        alertViewController.alertViewContentView = tfLink
        
        self.presentViewController(alertViewController, animated: true, completion: nil)
        
    }
    
    func showPickerView() {
        let manager = PHImageManager.defaultManager()
        
        let vc = BSImagePickerViewController()
        vc.maxNumberOfSelections = 1
        
        bs_presentImagePickerController(vc, animated: true,
            select: { (asset: PHAsset) -> Void in
                print("Selected: \(asset)")
            }, deselect: { (asset: PHAsset) -> Void in
                print("Deselected: \(asset)")
            }, cancel: { (assets: [PHAsset]) -> Void in
                print("Cancel: \(assets)")
            }, finish: { (assets: [PHAsset]) -> Void in
                print("Finish: \(assets)")
                let selectedAsset = assets[0]
                let targetSize = CGSize(width: selectedAsset.pixelWidth, height: selectedAsset.pixelHeight)
                let deliveryOptions = PHImageRequestOptionsDeliveryMode.HighQualityFormat
                let requestOptions = PHImageRequestOptions()
                
                requestOptions.deliveryMode = deliveryOptions
                
                manager.requestImageForAsset(selectedAsset, targetSize: targetSize, contentMode: PHImageContentMode.AspectFill, options: requestOptions, resultHandler: { (image, properties) -> Void in
                    //
                    if let _ = self.currentObject {
                        self.productImageFromParse.image = image
                    } else {
                        self.productImage.image = image
                    }
                })
            }, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField === tfProductName) {
            tfProductDes.becomeFirstResponder()
        } else if textField === tfProductDes {
            tfProductDes.resignFirstResponder()
        }
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}
