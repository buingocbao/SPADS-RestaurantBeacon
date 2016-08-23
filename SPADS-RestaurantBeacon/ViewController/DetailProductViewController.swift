//
//  DetailProductViewController.swift
//  SPADS-RestaurantBeacon
//
//  Created by BBaoBao on 8/13/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class DetailProductViewController: UIViewController {
    
    // MARK: Variables
    var productObject:PFObject!
    var productImage:UIImageView = UIImageView()
    var productDes:UITextView = UITextView()
    var titleLabel = UILabel()
    let gradientView = GradientView()
    var isExpanded:Bool!
    var backButton:MKButton = MKButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.blackColor()
        
        let bounds: CGRect = UIScreen.mainScreen().bounds
        let dvWidth:CGFloat = bounds.size.width
        let dvHeight:CGFloat = bounds.size.height
        
        isExpanded = false
        
        // Do any additional setup after loading the view.
        
        // Set drink label
        titleLabel.frame = CGRect(x: 0, y: dvHeight*2/3-50, width: dvWidth, height: 50)
        titleLabel.frame.insetInPlace(dx: 10, dy: 10)
        let priceFile:String = productObject["ProductPrice"] as! String
        titleLabel.attributedText = NSAttributedString.attributedStringForTitleText(productObject["ProductName"] as! String + " - " + priceFile)
        titleLabel.font = UIFont(name: "Helvetica-Light", size: 30)
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.numberOfLines = 3
        titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.view.addSubview(titleLabel)
        //self.view.bringSubviewToFront(titleLabel)
        
        // Set drink description
        let desFile:String = productObject["ProductDescription"] as! String
        productDes.frame = CGRect(x: 0, y: dvHeight*2/3, width: dvWidth, height: 100)
        productDes.text = desFile
        productDes.font = UIFont(name: "Helvetica-Light", size: 15)
        productDes.textColor = UIColor.whiteColor()
        productDes.backgroundColor = UIColor.blackColor()
        productDes.editable = false
        productDes.selectable = false
        self.view.addSubview(self.productDes)
        self.view.bringSubviewToFront(self.productDes)
        
        // Set drink image
        let imageFile:PFFile = productObject["ProductImage"] as! PFFile
        imageFile.getDataInBackgroundWithBlock({(data, error) in
            if error == nil {
                self.productImage.frame = CGRect(x: 0, y: 0, width: dvWidth, height: (dvWidth*363)/305)
                self.productImage.image = UIImage(data: data!)
                self.view.addSubview(self.productImage)
                self.view.sendSubviewToBack(self.productImage)
                self.productImage.addSubview(self.gradientView)
                self.gradientView.frame = FrameCalculator.frameForGradient(featureImageFrame: self.productImage.frame)
                self.gradientView.setNeedsDisplay()
            }
        })
        
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
        backButton.addTarget(self, action: "backButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(backButton)
        self.view.bringSubviewToFront(backButton)
    }
    
    func backButtonClick(button:UIButton) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
