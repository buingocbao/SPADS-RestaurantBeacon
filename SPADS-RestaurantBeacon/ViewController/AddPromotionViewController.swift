//
//  AddPromotionViewController.swift
//  SPADS-RestaurantBeacon
//
//  Created by BBaoBao on 8/15/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos

class AddPromotionViewController: UIViewController, UITextFieldDelegate {
    
    var backButton: MKButton = MKButton()
    var scrollView: UIScrollView!
    var lbMainText: String = String()
    var currentObject: PFObject?
    var commitButton: MKButton = MKButton()
    var isCheckedForCommit = false
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x:0, y: 0, width: 100, height: 100), type: NVActivityIndicatorType.BallClipRotateMultiple, color: UIColor.whiteColor(), size: CGSize(width: 100, height: 100))

    
    // Labels
    var lbMain: UILabel!
    var lbPromotionName: UILabel!
    var lbPromotionDes: UILabel!
    var lbPromotionImage: UILabel!
    var lbPromotionStart: UILabel!
    var lbPromotionEnd: UILabel!
    
    // Text Field
    var tfPromotionName: MKTextField!
    var tfPromotionDes: MKTextField!
    var tfPromotionStartHour: MKTextField!
    var tfPromotionStartMinute: MKTextField!
    var tfPromotionEndHour: MKTextField!
    var tfPromotionEndMinute: MKTextField!
    
    // Buttons
    var btImageLink: MKButton!
    var btImageUpload: MKButton!
    
    // Image View
    var promotionImage: UIImageView!
    var promotionImageFromParse: PFImageView!

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
        lbPromotionName = UILabel(frame: CGRect(x: 5, y: 0, width: self.view.frame.width/2, height: 20))
        lbPromotionName.font = UIFont(name: "AvenirNext-Regular", size: 20)
        lbPromotionName.textColor = UIColor.whiteColor()
        lbPromotionName.textAlignment = .Left
        lbPromotionName.text = "Promotion Name"
        self.scrollView.addSubview(lbPromotionName)
        lbPromotionName.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintLBName = NSLayoutConstraint(item: lbPromotionName, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:lbMain, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 20)
        let leftConstraintLBName = NSLayoutConstraint(item: lbPromotionName, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:scrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
        view.addConstraints([topConstraintLBName,leftConstraintLBName])
        
        // 3.Promotion Name TextField
        tfPromotionName = MKTextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: 100))
        tfPromotionName.layer.borderColor = UIColor.clearColor().CGColor
        tfPromotionName.floatingPlaceholderEnabled = true
        tfPromotionName.placeholder = "Name"
        tfPromotionName.tintColor = UIColor.whiteColor()
        tfPromotionName.textColor = UIColor.whiteColor()
        tfPromotionName.rippleLocation = .Right
        tfPromotionName.cornerRadius = 0
        tfPromotionName.bottomBorderEnabled = true
        tfPromotionName.borderStyle = UITextBorderStyle.None
        tfPromotionName.minimumFontSize = 17
        tfPromotionName.font = UIFont(name: "HelveticaNeue", size: 20)
        tfPromotionName.clearButtonMode = UITextFieldViewMode.UnlessEditing
        tfPromotionName.delegate = self
        self.scrollView.addSubview(tfPromotionName)
        tfPromotionName.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintTFName = NSLayoutConstraint(item: tfPromotionName, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:lbPromotionName, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 5)
        let leftConstraintTFName = NSLayoutConstraint(item: tfPromotionName, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:scrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
        let widthConstraintTFName = NSLayoutConstraint(item: tfPromotionName, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width/2)
        let heightConstraintTFName = NSLayoutConstraint(item: tfPromotionName, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
        view.addConstraints([topConstraintTFName,leftConstraintTFName, widthConstraintTFName, heightConstraintTFName])
        
        if let object = currentObject {
            tfPromotionName.text = object["PromotionName"] as? String
        }
        
        
        // 4.Promotion Description Label
        lbPromotionDes = UILabel(frame: CGRect(x: 5, y: 0, width: self.view.frame.width/2, height: 20))
        lbPromotionDes.font = UIFont(name: "AvenirNext-Regular", size: 20)
        lbPromotionDes.textColor = UIColor.whiteColor()
        lbPromotionDes.textAlignment = .Left
        lbPromotionDes.text = "Promotion Description"
        self.scrollView.addSubview(lbPromotionDes)
        lbPromotionDes.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintLBDes = NSLayoutConstraint(item: lbPromotionDes, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:tfPromotionName, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 10)
        let leftConstraintLBDes = NSLayoutConstraint(item: lbPromotionDes, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:scrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
        view.addConstraints([topConstraintLBDes,leftConstraintLBDes])
        
        // 5.Promotion Description TextField
        tfPromotionDes = MKTextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: 50))
        tfPromotionDes.layer.borderColor = UIColor.clearColor().CGColor
        tfPromotionDes.floatingPlaceholderEnabled = true
        tfPromotionDes.placeholder = "Description"
        tfPromotionDes.tintColor = UIColor.whiteColor()
        tfPromotionDes.textColor = UIColor.whiteColor()
        tfPromotionDes.rippleLocation = .Right
        tfPromotionDes.cornerRadius = 0
        tfPromotionDes.bottomBorderEnabled = true
        tfPromotionDes.borderStyle = UITextBorderStyle.None
        tfPromotionDes.minimumFontSize = 17
        tfPromotionDes.font = UIFont(name: "HelveticaNeue", size: 20)
        tfPromotionDes.clearButtonMode = UITextFieldViewMode.UnlessEditing
        tfPromotionDes.delegate = self
        self.scrollView.addSubview(tfPromotionDes)
        tfPromotionDes.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintTFDes = NSLayoutConstraint(item: tfPromotionDes, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:lbPromotionDes, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 5)
        let leftConstraintTFDes = NSLayoutConstraint(item: tfPromotionDes, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:scrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
        let widthConstraintTFDes = NSLayoutConstraint(item: tfPromotionDes, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width-20)
        let heightConstraintTFDes = NSLayoutConstraint(item: tfPromotionDes, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
        view.addConstraints([topConstraintTFDes,leftConstraintTFDes, widthConstraintTFDes, heightConstraintTFDes])
        
        if let object = currentObject {
            tfPromotionDes.text = object["PromotionDescription"] as? String
        }
        
        // 6.Promotion Image Label
        lbPromotionImage = UILabel(frame: CGRect(x: 5, y: 0, width: self.view.frame.width/2, height: 20))
        lbPromotionImage.font = UIFont(name: "AvenirNext-Regular", size: 20)
        lbPromotionImage.textColor = UIColor.whiteColor()
        lbPromotionImage.textAlignment = .Left
        lbPromotionImage.text = "Promotion Image"
        self.scrollView.addSubview(lbPromotionImage)
        lbPromotionImage.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintLBImage = NSLayoutConstraint(item: lbPromotionImage, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:tfPromotionDes, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 10)
        let leftConstraintLBImage = NSLayoutConstraint(item: lbPromotionImage, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:scrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
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
        let topConstraintBTImageAdd = NSLayoutConstraint(item: btImageLink, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:lbPromotionImage, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 10)
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
        let topConstraintBTImageUpload = NSLayoutConstraint(item: btImageUpload, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:lbPromotionImage, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 10)
        let leftConstraintBTImageUpload = NSLayoutConstraint(item: btImageUpload, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:btImageLink, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
        let widthConstraintBTImageUpload = NSLayoutConstraint(item: btImageUpload, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width/2-20)
        let heightConstraintBTImageUpload = NSLayoutConstraint(item: btImageUpload, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
        view.addConstraints([topConstraintBTImageUpload,leftConstraintBTImageUpload, widthConstraintBTImageUpload, heightConstraintBTImageUpload])
        
        // 9.Promotion UIImageView
        if let object = currentObject {
            promotionImageFromParse = PFImageView(frame: CGRect(x: 5, y: 0, width: self.view.frame.width-20, height: 50))
            promotionImageFromParse.image = UIImage(named: "PromotionImage")
            promotionImageFromParse.contentMode = UIViewContentMode.ScaleAspectFit
            self.scrollView.addSubview(promotionImageFromParse)
            promotionImageFromParse.translatesAutoresizingMaskIntoConstraints = false
            let topConstraintImage = NSLayoutConstraint(item: promotionImageFromParse, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: btImageLink, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 10)
            let leftConstraintImage = NSLayoutConstraint(item: promotionImageFromParse, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: scrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
            let widthConstraintImage = NSLayoutConstraint(item: promotionImageFromParse, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width-20)
            let heightConstraintImage = NSLayoutConstraint(item: promotionImageFromParse, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.height/2)
            view.addConstraints([topConstraintImage, leftConstraintImage, widthConstraintImage, heightConstraintImage])
            
            promotionImageFromParse.file = object["PromotionImage"] as? PFFile
        } else {
            promotionImage = UIImageView(frame: CGRect(x: 5, y: 0, width: self.view.frame.width-20, height: 50))
            promotionImage.image = UIImage(named: "PromotionImage")
            promotionImage.contentMode = UIViewContentMode.ScaleAspectFit
            self.scrollView.addSubview(promotionImage)
            promotionImage.translatesAutoresizingMaskIntoConstraints = false
            let topConstraintImage = NSLayoutConstraint(item: promotionImage, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: btImageLink, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 10)
            let leftConstraintImage = NSLayoutConstraint(item: promotionImage, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: scrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
            let widthConstraintImage = NSLayoutConstraint(item: promotionImage, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width-20)
            let heightConstraintImage = NSLayoutConstraint(item: promotionImage, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.height/2)
            view.addConstraints([topConstraintImage, leftConstraintImage, widthConstraintImage, heightConstraintImage])
        }
        
        // 10.Promotion Start Hour
        lbPromotionStart = UILabel(frame: CGRect(x: 5, y: 0, width: self.view.frame.width/2, height: 20))
        lbPromotionStart.font = UIFont(name: "AvenirNext-Regular", size: 20)
        lbPromotionStart.textColor = UIColor.whiteColor()
        lbPromotionStart.textAlignment = .Left
        lbPromotionStart.text = "Start Time"
        self.scrollView.addSubview(lbPromotionStart)
        lbPromotionStart.translatesAutoresizingMaskIntoConstraints = false
        var topConstraintLBStart = NSLayoutConstraint()
        if let _ = currentObject {
            topConstraintLBStart = NSLayoutConstraint(item: lbPromotionStart, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: promotionImageFromParse, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 10)
        } else {
            topConstraintLBStart = NSLayoutConstraint(item: lbPromotionStart, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: promotionImage, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 10)
        }
        let leftConstraintLBStart = NSLayoutConstraint(item: lbPromotionStart, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:scrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
        let widthConstraintLBStart = NSLayoutConstraint(item: lbPromotionStart, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width/2-20)
        view.addConstraints([topConstraintLBStart,leftConstraintLBStart, widthConstraintLBStart])
        
        // 11.Promotion End Hour
        lbPromotionEnd = UILabel(frame: CGRect(x: 5, y: 0, width: self.view.frame.width/2, height: 20))
        lbPromotionEnd.font = UIFont(name: "AvenirNext-Regular", size: 20)
        lbPromotionEnd.textColor = UIColor.whiteColor()
        lbPromotionEnd.textAlignment = .Left
        lbPromotionEnd.text = "End Time"
        self.scrollView.addSubview(lbPromotionEnd)
        lbPromotionEnd.translatesAutoresizingMaskIntoConstraints = false
        var topConstraintLBEnd = NSLayoutConstraint()
        if let _ = currentObject {
            topConstraintLBEnd = NSLayoutConstraint(item: lbPromotionEnd, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: promotionImageFromParse, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 10)
        } else {
            topConstraintLBEnd = NSLayoutConstraint(item: lbPromotionEnd, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: promotionImage, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 10)
        }
        let leftConstraintLBEnd = NSLayoutConstraint(item: lbPromotionEnd, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: lbPromotionStart, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 20)
        view.addConstraints([topConstraintLBEnd,leftConstraintLBEnd])
        
        // 12.Promotion Start Hour Textfield
        tfPromotionStartHour = MKTextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: 50))
        tfPromotionStartHour.layer.borderColor = UIColor.clearColor().CGColor
        tfPromotionStartHour.floatingPlaceholderEnabled = true
        tfPromotionStartHour.placeholder = "H"
        tfPromotionStartHour.tintColor = UIColor.whiteColor()
        tfPromotionStartHour.textColor = UIColor.whiteColor()
        tfPromotionStartHour.rippleLocation = .Right
        tfPromotionStartHour.cornerRadius = 0
        tfPromotionStartHour.bottomBorderEnabled = true
        tfPromotionStartHour.borderStyle = UITextBorderStyle.None
        tfPromotionStartHour.minimumFontSize = 17
        tfPromotionStartHour.keyboardType = UIKeyboardType.NumberPad
        tfPromotionStartHour.font = UIFont(name: "HelveticaNeue", size: 20)
        tfPromotionStartHour.delegate = self
        self.scrollView.addSubview(tfPromotionStartHour)
        tfPromotionStartHour.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintTFStartHour = NSLayoutConstraint(item: tfPromotionStartHour, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:lbPromotionStart, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 5)
        let leftConstraintTFStartHour = NSLayoutConstraint(item: tfPromotionStartHour, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:scrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
        let widthConstraintTFStartHour = NSLayoutConstraint(item: tfPromotionStartHour, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width/6)
        let heightConstraintTFStartHour = NSLayoutConstraint(item: tfPromotionStartHour, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
        view.addConstraints([topConstraintTFStartHour,leftConstraintTFStartHour, widthConstraintTFStartHour, heightConstraintTFStartHour])
        
        // 13.Promotion Start Minute Textfield
        tfPromotionStartMinute = MKTextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: 50))
        tfPromotionStartMinute.layer.borderColor = UIColor.clearColor().CGColor
        tfPromotionStartMinute.floatingPlaceholderEnabled = true
        tfPromotionStartMinute.placeholder = "M"
        tfPromotionStartMinute.text = "00"
        tfPromotionStartMinute.tintColor = UIColor.whiteColor()
        tfPromotionStartMinute.textColor = UIColor.whiteColor()
        tfPromotionStartMinute.rippleLocation = .Right
        tfPromotionStartMinute.cornerRadius = 0
        tfPromotionStartMinute.bottomBorderEnabled = true
        tfPromotionStartMinute.borderStyle = UITextBorderStyle.None
        tfPromotionStartMinute.minimumFontSize = 17
        tfPromotionStartMinute.keyboardType = UIKeyboardType.NumberPad
        tfPromotionStartMinute.font = UIFont(name: "HelveticaNeue", size: 20)
        tfPromotionStartMinute.delegate = self
        self.scrollView.addSubview(tfPromotionStartMinute)
        tfPromotionStartMinute.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintTFStartMinute = NSLayoutConstraint(item: tfPromotionStartMinute, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:lbPromotionStart, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 5)
        let leftConstraintTFStartMinute = NSLayoutConstraint(item: tfPromotionStartMinute, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:tfPromotionStartHour, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 5)
        let widthConstraintTFStartMinute = NSLayoutConstraint(item: tfPromotionStartMinute, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width/6)
        let heightConstraintTFStartMinute = NSLayoutConstraint(item: tfPromotionStartMinute, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
        view.addConstraints([topConstraintTFStartMinute,leftConstraintTFStartMinute, widthConstraintTFStartMinute, heightConstraintTFStartMinute])
        
        // Post-12&13. Define start time: Hour and Minute
        if let object = currentObject {
            var promotionStartTime = (object["StartHour"] as! String).characters.split {$0 == ":"}.map { String($0) }
            let promotionStartHour:String = promotionStartTime[0]
            let promotionEndHour:String = promotionStartTime[1]
            tfPromotionStartHour.text = promotionStartHour
            tfPromotionStartMinute.text = promotionEndHour
        }
        
        // 14.Promotion End Hour Textfield
        tfPromotionEndHour = MKTextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: 50))
        tfPromotionEndHour.layer.borderColor = UIColor.clearColor().CGColor
        tfPromotionEndHour.floatingPlaceholderEnabled = true
        tfPromotionEndHour.placeholder = "H"
        tfPromotionEndHour.tintColor = UIColor.whiteColor()
        tfPromotionEndHour.textColor = UIColor.whiteColor()
        tfPromotionEndHour.rippleLocation = .Right
        tfPromotionEndHour.cornerRadius = 0
        tfPromotionEndHour.bottomBorderEnabled = true
        tfPromotionEndHour.borderStyle = UITextBorderStyle.None
        tfPromotionEndHour.minimumFontSize = 17
        tfPromotionEndHour.keyboardType = UIKeyboardType.NumberPad
        tfPromotionEndHour.font = UIFont(name: "HelveticaNeue", size: 20)
        tfPromotionEndHour.delegate = self
        self.scrollView.addSubview(tfPromotionEndHour)
        tfPromotionEndHour.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintTFEndHour = NSLayoutConstraint(item: tfPromotionEndHour, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:lbPromotionEnd, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 5)
        let leftConstraintTFEndHour = NSLayoutConstraint(item: tfPromotionEndHour, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem:lbPromotionEnd, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
        let widthConstraintTFEndHour = NSLayoutConstraint(item: tfPromotionEndHour, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width/6)
        let heightConstraintTFEndHour = NSLayoutConstraint(item: tfPromotionEndHour, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
        view.addConstraints([topConstraintTFEndHour,leftConstraintTFEndHour, widthConstraintTFEndHour, heightConstraintTFEndHour])
        
        // 15.Promotion End Minute Textfield
        tfPromotionEndMinute = MKTextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: 50))
        tfPromotionEndMinute.layer.borderColor = UIColor.clearColor().CGColor
        tfPromotionEndMinute.floatingPlaceholderEnabled = true
        tfPromotionEndMinute.placeholder = "M"
        tfPromotionEndMinute.text = "00"
        tfPromotionEndMinute.tintColor = UIColor.whiteColor()
        tfPromotionEndMinute.textColor = UIColor.whiteColor()
        tfPromotionEndMinute.rippleLocation = .Right
        tfPromotionEndMinute.cornerRadius = 0
        tfPromotionEndMinute.bottomBorderEnabled = true
        tfPromotionEndMinute.borderStyle = UITextBorderStyle.None
        tfPromotionEndMinute.minimumFontSize = 17
        tfPromotionEndMinute.keyboardType = UIKeyboardType.NumberPad
        tfPromotionEndMinute.font = UIFont(name: "HelveticaNeue", size: 20)
        tfPromotionEndMinute.delegate = self
        self.scrollView.addSubview(tfPromotionEndMinute)
        tfPromotionEndMinute.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintTFEndMinute = NSLayoutConstraint(item: tfPromotionEndMinute, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:lbPromotionEnd, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 5)
        let leftConstraintTFEndMinute = NSLayoutConstraint(item: tfPromotionEndMinute, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:tfPromotionEndHour, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
        let widthConstraintTFEndMinute = NSLayoutConstraint(item: tfPromotionEndMinute, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width/6)
        let heightConstraintTFEndMinute = NSLayoutConstraint(item: tfPromotionEndMinute, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
        view.addConstraints([topConstraintTFEndMinute,leftConstraintTFEndMinute, widthConstraintTFEndMinute, heightConstraintTFEndMinute])
        
        // Post-14&15. Define End time: Hour and Minute
        if let object = currentObject {
            var promotionEndTime = (object["EndHour"] as! String).characters.split {$0 == ":"}.map { String($0) }
            let promotionStartHour:String = promotionEndTime[0]
            let promotionEndHour:String = promotionEndTime[1]
            tfPromotionEndHour.text = promotionStartHour
            tfPromotionEndMinute.text = promotionEndHour
        }
        
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
        let topConstraintBTCommit = NSLayoutConstraint(item: commitButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:tfPromotionEndMinute, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 20)
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
        if tfPromotionName.text == "" {
            let missAlertViewController:NYAlertViewController = NYAlertViewController()
            missAlertViewController.addAction(NYAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            missAlertViewController.title = "Missing"
            missAlertViewController.message = "Please fill Promotion Name!"
            missAlertViewController.titleColor = UIColor.MKColor.Orange
            self.presentViewController(missAlertViewController, animated: true, completion: nil)
        } else
            if tfPromotionDes.text == "" {
                let missAlertViewController:NYAlertViewController = NYAlertViewController()
                missAlertViewController.addAction(NYAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                }))
                missAlertViewController.title = "Missing"
                missAlertViewController.message = "Please fill Promotion Description!"
                missAlertViewController.titleColor = UIColor.MKColor.Orange
                self.presentViewController(missAlertViewController, animated: true, completion: nil)
            } else
                if tfPromotionStartHour.text == "" {
                    let missAlertViewController:NYAlertViewController = NYAlertViewController()
                    missAlertViewController.addAction(NYAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }))
                    missAlertViewController.title = "Missing"
                    missAlertViewController.message = "Please fill Promotion Start Hour!"
                    missAlertViewController.titleColor = UIColor.MKColor.Orange
                    self.presentViewController(missAlertViewController, animated: true, completion: nil)
                } else if Int(tfPromotionStartHour.text!)! > 23 {
                    let wrongAlertViewController:NYAlertViewController = NYAlertViewController()
                    wrongAlertViewController.addAction(NYAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }))
                    wrongAlertViewController.title = "Wrong"
                    wrongAlertViewController.message = "Promotion Start Hour cannot greater than 23!"
                    wrongAlertViewController.titleColor = UIColor.MKColor.Orange
                    self.presentViewController(wrongAlertViewController, animated: true, completion: nil)
                } else
                    if tfPromotionStartMinute.text == "" {
                        let missAlertViewController:NYAlertViewController = NYAlertViewController()
                        missAlertViewController.addAction(NYAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }))
                        missAlertViewController.title = "Missing"
                        missAlertViewController.message = "Please fill Promotion Start Minute!"
                        missAlertViewController.titleColor = UIColor.MKColor.Orange
                        self.presentViewController(missAlertViewController, animated: true, completion: nil)
                    } else if Int(tfPromotionStartMinute.text!)! > 59 {
                        let wrongAlertViewController:NYAlertViewController = NYAlertViewController()
                        wrongAlertViewController.addAction(NYAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }))
                        wrongAlertViewController.title = "Wrong"
                        wrongAlertViewController.message = "Promotion Start Minute cannot greater than 59!"
                        wrongAlertViewController.titleColor = UIColor.MKColor.Orange
                        self.presentViewController(wrongAlertViewController, animated: true, completion: nil)
                    } else
                        if tfPromotionEndHour.text == "" {
                            let missAlertViewController:NYAlertViewController = NYAlertViewController()
                            missAlertViewController.addAction(NYAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }))
                            missAlertViewController.title = "Missing"
                            missAlertViewController.message = "Please fill Promotion End Hour!"
                            missAlertViewController.titleColor = UIColor.MKColor.Orange
                            self.presentViewController(missAlertViewController, animated: true, completion: nil)
                        } else if Int(tfPromotionEndHour.text!)! > 23{
                            let wrongAlertViewController:NYAlertViewController = NYAlertViewController()
                            wrongAlertViewController.addAction(NYAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }))
                            wrongAlertViewController.title = "Wrong"
                            wrongAlertViewController.message = "Promotion End Hour cannot greater than 23!"
                            self.presentViewController(wrongAlertViewController, animated: true, completion: nil)
                        } else
                            if tfPromotionEndMinute.text == "" {
                                let missAlertViewController:NYAlertViewController = NYAlertViewController()
                                missAlertViewController.addAction(NYAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                                    self.dismissViewControllerAnimated(true, completion: nil)
                                }))
                                missAlertViewController.title = "Missing"
                                missAlertViewController.message = "Please fill Promotion End Minute!"
                                missAlertViewController.titleColor = UIColor.MKColor.Orange
                                self.presentViewController(missAlertViewController, animated: true, completion: nil)
                            } else if Int(tfPromotionEndMinute.text!)! > 59 {
                                let wrongAlertViewController:NYAlertViewController = NYAlertViewController()
                                wrongAlertViewController.addAction(NYAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                                    self.dismissViewControllerAnimated(true, completion: nil)
                                }))
                                wrongAlertViewController.title = "Wrong"
                                wrongAlertViewController.message = "Promotion End Minute cannot greater than 59!"
                                wrongAlertViewController.titleColor = UIColor.MKColor.Orange
                                self.presentViewController(wrongAlertViewController, animated: true, completion: nil)
                            } else {
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
                                    object["PromotionName"] = tfPromotionName.text
                                    object["PromotionDescription"] = tfPromotionDes.text
                                    object["StartHour"] = "\(tfPromotionStartHour.text):\(tfPromotionStartMinute.text)"
                                    object["EndHour"] = "\(tfPromotionEndHour.text):\(tfPromotionEndMinute.text)"
                                    
                                    let imageData:NSData = UIImagePNGRepresentation(self.promotionImageFromParse.image!)!
                                    let imageFile:PFFile = PFFile(name: "Promotion-\(imageName).png", data: imageData)
                                    object["PromotionImage"] = imageFile
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
                                            successAlertViewController.message = "You successfully updated promotion!"
                                            successAlertViewController.titleColor = UIColor.MKColor.Orange
                                            successAlertViewController.buttonColor = UIColor.MKColor.Green
                                            successAlertViewController.buttonTitleColor = UIColor(white: 0.19, alpha: 1.0)
                                            self.presentViewController(successAlertViewController, animated: true, completion: nil)
                                        }
                                    })
                                } else {
                                    let object = PFObject(className: "Promotion")
                                    object.setObject(tfPromotionName.text!, forKey: "PromotionName")
                                    object.setObject(tfPromotionDes.text!, forKey: "PromotionDescription")
                                    object.setObject("\(tfPromotionStartHour.text):\(tfPromotionStartMinute.text)", forKey: "StartHour")
                                    object.setObject("\(tfPromotionEndHour.text):\(tfPromotionEndMinute.text)", forKey: "EndHour")
                                    let imageData:NSData = UIImagePNGRepresentation(self.promotionImage.image!)!
                                    let imageFile:PFFile = PFFile(name: "Promotion-\(imageName).png", data: imageData)
                                    object.setObject(imageFile, forKey: "PromotionImage")
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
                                            successAlertViewController.message = "You successfully created new promotion!"
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
                        self.promotionImageFromParse.image = image
                    } else {
                        self.promotionImage.image = image
                    }
                })
            }, completion: nil)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField === tfPromotionName) {
            tfPromotionDes.becomeFirstResponder()
        } else if textField === tfPromotionDes {
            tfPromotionDes.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
