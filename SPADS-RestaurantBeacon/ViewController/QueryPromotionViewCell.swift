//
//  QueryPromotionViewCell.swift
//  SPADS-RestaurantBeacon
//
//  Created by BBaoBao on 8/14/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class QueryPromotionViewCell: PFTableViewCell {
   
    @IBOutlet weak var promotionName: UILabel!
    
    @IBOutlet weak var promotionDescription: UILabel!
    
    @IBOutlet weak var shortPromotionDes: UILabel!
    @IBOutlet weak var productImage: PFImageView!
    
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var startHourLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var endHourLabel: UILabel!
    
    
    var frameAdded = false
    
    class var expandableHeight: CGFloat { get {return 250}}
    class var defaultHeight: CGFloat { get {return 60}}
    
    func checkHeight() {
        promotionDescription.hidden = (frame.size.height < QueryPromotionViewCell.expandableHeight)
        shortPromotionDes.hidden = !promotionDescription.hidden
        productImage.hidden = promotionDescription.hidden
        startTimeLabel.hidden = promotionDescription.hidden
        startHourLabel.hidden = promotionDescription.hidden
        endTimeLabel.hidden = promotionDescription.hidden
        endHourLabel.hidden = promotionDescription.hidden
    }
    
    func watchFrameChanges(){
        if(!frameAdded){
            addObserver(self, forKeyPath: "frame", options: [NSKeyValueObservingOptions.New, NSKeyValueObservingOptions.Initial], context: nil)
            frameAdded = true
        }
        //checkHeight()
    }
    
    func ignoreFrameChanges() {
        if(frameAdded){
            removeObserver(self, forKeyPath: "frame")
            frameAdded = false
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "frame" {
            checkHeight()
        }
    }
    
    deinit {
        ignoreFrameChanges()
    }
    
}
