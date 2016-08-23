//
//  SADetailViewController.swift
//  SAParallaxViewControllerSwift
//
//  Created by 鈴木大貴 on 2015/02/05.
//  Copyright (c) 2015年 鈴木大貴. All rights reserved.
//

import UIKit

public class SADetailViewController: UIViewController {

    public var trantisionContainerView: SATransitionContainerView?
    public var imageView = UIImageView()
    
    public var headerView: UIView?
    public var closeButton: MKButton?
    public var restaurantID: String?
    public var restaurantName: String?
    public var restaurantAddress: String?
    public var restaurantTel: String?
    private var headerColorView: UIView?
    private var headerImageView: UIImageView?
    private var headerContainerView: UIView?
    private var blurImageView: UIImageView?
    private var webViewBG: UIWebView?
    private var restaurantNameLabel: UILabel?
    private var restaurantAddressLabel: UILabel?
    private var restaurantTelLabel:UILabel?
    private var restaurantTelButton:MKButton?
    
    private let kHeaderViewHeight: CGFloat = 40
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.MKColor.Green
        
        let width = UIScreen.mainScreen().bounds.size.width
        imageView.image = trantisionContainerView?.containerView?.imageView.image
        if let imageSize = imageView.image?.size {
            let height = width * imageSize.height / imageSize.width
            imageView.autoresizingMask = .None
            imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            view.addSubview(imageView)
        }
        
        let filePath = NSBundle.mainBundle().pathForResource("RestaurantGif", ofType: "gif")
        let gif = NSData(contentsOfFile: filePath!)
        let webViewBG = UIWebView(frame: CGRect(x: 0, y: imageView.frame.height, width: self.view.frame.width, height: (self.view.frame.height - imageView.frame.height)))
        webViewBG.loadData(gif!, MIMEType: "image/gif", textEncodingName: "utf-8", baseURL:  NSURL(string: "http://localhost/")!)
        webViewBG.userInteractionEnabled = false;
        self.view.addSubview(webViewBG)
        self.view.sendSubviewToBack(webViewBG)
        self.webViewBG = webViewBG
        
        let gifFilter = UIView()
        gifFilter.frame = webViewBG.frame
        gifFilter.backgroundColor = UIColor.blackColor()
        gifFilter.alpha = 0.2
        self.view.addSubview(gifFilter)
        
        let headerContainerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: width, height: kHeaderViewHeight))
        headerContainerView.alpha = 0.0
        headerContainerView.clipsToBounds = true
        view.addSubview(headerContainerView)
        self.headerContainerView = headerContainerView
        
        let blurImageView = UIImageView(frame: imageView.bounds)
        blurImageView.image = imageView.image?.blur(20.0)
        headerContainerView.addSubview(blurImageView)
        self.blurImageView = blurImageView
        
        let headerColorView = UIView(frame: headerContainerView.bounds)
        headerColorView.backgroundColor = .blackColor()
        headerColorView.alpha = 0.5
        headerContainerView.addSubview(headerColorView)
        self.headerColorView = headerColorView
        
        let headerView = UIView(frame: headerContainerView.bounds)
        headerContainerView.addSubview(headerView)
        self.headerView = headerView

        let closeButton = MKButton(frame: CGRect(x: 15, y: 0, width: 40, height: 40))
        closeButton.backgroundColor = UIColor.MKColor.Red
        closeButton.cornerRadius = 20.0
        closeButton.backgroundLayerCornerRadius = 20.0
        closeButton.maskEnabled = false
        closeButton.rippleLocation = .Center
        closeButton.ripplePercent = 1.75
        closeButton.layer.shadowOpacity = 0.75
        closeButton.layer.shadowRadius = 3.5
        closeButton.layer.shadowColor = UIColor.blackColor().CGColor
        closeButton.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        closeButton.addTarget(self, action: "closeAction:", forControlEvents: UIControlEvents.TouchUpInside)
        headerView.addSubview(closeButton)
        self.closeButton = closeButton
        
        let restaurantNameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: kHeaderViewHeight))
        restaurantNameLabel.center = headerView.center
        restaurantNameLabel.textAlignment = NSTextAlignment.Center
        restaurantNameLabel.font = UIFont(name: "Helvetica Neue", size: 30)
        restaurantNameLabel.text = restaurantName
        restaurantNameLabel.textColor = .whiteColor()
        headerView.addSubview(restaurantNameLabel)
        self.restaurantNameLabel = restaurantNameLabel
        
        let addressFilter = UIView()
        addressFilter.frame = CGRect(x: 0, y: imageView.frame.height-50, width: width, height: 50)
        addressFilter.backgroundColor = UIColor.blackColor()
        addressFilter.alpha = 0.5
        self.view.addSubview(addressFilter)
        
        let restaurantAddressLabel = UILabel(frame: CGRect(x: 0, y: imageView.frame.height-50, width: width, height: 50))
        restaurantAddressLabel.textAlignment = NSTextAlignment.Center
        restaurantAddressLabel.numberOfLines = 0
        restaurantAddressLabel.font = UIFont(name: "Helvetica Neue", size: 20)
        restaurantAddressLabel.text = restaurantAddress
        restaurantAddressLabel.textColor = .whiteColor()
        restaurantAddressLabel.backgroundColor = .clearColor()
        restaurantAddressLabel.alpha = 0
        self.view.addSubview(restaurantAddressLabel)
        self.restaurantAddressLabel = restaurantAddressLabel
        
        let restaurantTelButton = MKButton(frame: CGRect(x: 0, y: imageView.frame.height-80, width: self.view.frame.width/2, height: 30))
        restaurantTelButton.backgroundColor = UIColor.clearColor()
        restaurantTelButton.layer.shadowOpacity = 0.75
        restaurantTelButton.layer.shadowRadius = 3.5
        restaurantTelButton.layer.shadowColor = UIColor.blackColor().CGColor
        restaurantTelButton.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        restaurantTelButton.layer.borderWidth = 1.0
        restaurantTelButton.layer.borderColor = UIColor.MKColor.Blue.CGColor
        restaurantTelButton.alpha = 0
        restaurantTelButton.setTitle(restaurantTel, forState: UIControlState.Normal)
        restaurantTelButton.addTarget(self, action: "resTelButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(restaurantTelButton)
        self.restaurantTelButton = restaurantTelButton
    }
    
    func resTelButtonClick(button: UIButton) {
        let number = self.restaurantTel!.stringByReplacingOccurrencesOfString("-", withString: "", options: .LiteralSearch, range: nil)
        print(number)
        if let url = NSURL(string: "tel://\(number)") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveEaseIn, animations: {
            
            self.headerContainerView?.alpha = 1.0
            self.restaurantAddressLabel?.alpha = 1.0
            self.restaurantTelButton?.alpha = 1.0
            
        }, completion: { (finished) in })
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    public func closeAction(button: UIButton) {
        UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveEaseIn, animations: {
            
            self.headerContainerView?.alpha = 0.0
            
        }, completion: { (finished) in
            
            self.dismissViewControllerAnimated(true, completion: nil)
                
        })
    }
}
