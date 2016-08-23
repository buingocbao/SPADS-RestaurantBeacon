//
//  CentreViewController.swift
//  SPADS-RestaurantBeacon
//
//  Created by BBaoBao on 8/5/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class CentreViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Status bar
        
        //Instantiation and the setting of the size and position
        let swiftPagesView : SwiftPages!
        swiftPagesView = SwiftPages(frame: CGRectMake(0, UIApplication.sharedApplication().statusBarFrame.height, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
        
        //Initiation        
        var VCIDs : [String]
        VCIDs = ["PromotionVC", "RestaurantVC", "TabBarVC"]
        let buttonImages : [UIImage] = [UIImage(named:"Promotion.png")!,
            UIImage(named:"Menu.png")!,
            UIImage(named:"Setting.png")!]
        
        //Sample customization
        swiftPagesView.setOriginY(0.0)
        swiftPagesView.enableAeroEffectInTopBar(true)
        swiftPagesView.initializeWithVCIDsArrayAndButtonImagesArray(VCIDs, buttonImagesArray: buttonImages)
        //swiftPagesView.setTopBarBackground(UIColor.MKColor.Green)
        swiftPagesView.setAnimatedBarColor(UIColor(red: 255/255, green: 250/255, blue: 205/255, alpha: 1.0))
        
        self.view.addSubview(swiftPagesView)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}
