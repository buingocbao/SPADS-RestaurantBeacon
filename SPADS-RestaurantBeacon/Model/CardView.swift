//
//  CardView.swift
//  ZLSwipeableViewSwiftDemo
//
//  Created by BBaoBao on 8/5/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit
import ZLSwipeableViewSwift

protocol CardViewProtocol {
    func infoButtonClickProtocol(productObject: PFObject)
    func likeButtonClickProtocol(productObject: PFObject, likeButton: MKButton)
}

class CardView: UIView {
    
    var imageView:UIImageView = UIImageView()
    var infoButton:MKButton = MKButton()
    var likeButton:MKButton = MKButton()
    var productName:UILabel = UILabel()
    var productObject:PFObject!
    var delegate: CardViewProtocol?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        // Shadow
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.33
        layer.shadowOffset = CGSizeMake(0, 1.5)
        layer.shadowRadius = 4.0
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.mainScreen().scale
        
        // Corner Radius
        layer.cornerRadius = 10.0;
        
        // Config buttons
        configButtons()
    }
    
    func initImage(image:UIImage, width: CGFloat, height: CGFloat) {
        imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: height-100)
        imageView.contentMode = UIViewContentMode.ScaleToFill
        self.addSubview(imageView)
    }
    
    func setImage(data: NSData, width: CGFloat, height: CGFloat){
        imageView = UIImageView(image: UIImage(data: data))
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: height-100)
        imageView.contentMode = UIViewContentMode.ScaleToFill
        self.addSubview(imageView)
    }
    
    func getNameProduct(string: String) {
        productName.frame = CGRect(x: 0, y: self.frame.height-50-20, width: self.frame.width, height: 30)
        productName.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        productName.textAlignment = NSTextAlignment.Center
        productName.text = string
        productName.textColor = UIColor.whiteColor()
        self.addSubview(productName)
    }
    
    func configButtons() {
        infoButton.frame = CGRect(x: 10, y: self.frame.height-50, width: 40, height: 40)
        infoButton.backgroundColor = UIColor.MKColor.Orange
        infoButton.cornerRadius = 20.0
        infoButton.backgroundLayerCornerRadius = 20.0
        infoButton.maskEnabled = false
        infoButton.rippleLocation = .Center
        infoButton.ripplePercent = 1.75
        infoButton.layer.shadowOpacity = 0.75
        infoButton.layer.shadowRadius = 3.5
        infoButton.layer.shadowColor = UIColor.blackColor().CGColor
        infoButton.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        //backButton.setImage(UIImage(named: "Close"), forState: UIControlState.Normal)
        infoButton.setTitle("i", forState: UIControlState.Normal)
        infoButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 20)
        infoButton.addTarget(self, action: "infoButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(infoButton)
        
        likeButton.frame = CGRect(x: self.frame.width-50, y: self.frame.height-50, width: 40, height: 40)
        likeButton.backgroundColor = UIColor.MKColor.Pink
        likeButton.cornerRadius = 20.0
        likeButton.backgroundLayerCornerRadius = 20.0
        likeButton.maskEnabled = false
        likeButton.rippleLocation = .Center
        likeButton.ripplePercent = 1.75
        likeButton.layer.shadowOpacity = 0.75
        likeButton.layer.shadowRadius = 3.5
        likeButton.layer.shadowColor = UIColor.blackColor().CGColor
        likeButton.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        likeButton.setImage(UIImage(named: "heart.png"), forState: UIControlState.Normal)
        //likeButton.setTitle("", forState: UIControlState.Normal)
        //likeButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 20)
        likeButton.addTarget(self, action: "likeButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(likeButton)
    }
    
    func discardButtonClick(button:UIButton) {
        
    }
    
    func infoButtonClick() {
        delegate?.infoButtonClickProtocol(self.productObject)
    }
    
    func likeButtonClick() {
        delegate?.likeButtonClickProtocol(self.productObject, likeButton: self.likeButton)
    }
    
    func assignProductObject(product: PFObject) {
        productObject = product
    }
}
