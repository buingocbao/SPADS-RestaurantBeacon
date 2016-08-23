//
//  LoadingViewController.swift
//  SPADS-RestaurantBeacon
//
//  Created by BBaoBao on 8/22/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    var progressNum:Int = Int()
    var timer:NSTimer!
    var objectArray:NSArray = NSArray()
    var objectArrayToLocal:[PFObject] = [PFObject]()
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x:0, y: 0, width: 200, height: 200), type: NVActivityIndicatorType.BallClipRotateMultiple, color: UIColor.MKColor.Blue, size: CGSize(width: 200, height: 200))
    
    override func viewDidAppear(animated: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let _ = defaults.stringForKey("FirstLaunch"){
            //Second time run app
            if checkUpdateFlag() == false {
                self.performSegueWithIdentifier("MainScreenSegue", sender: nil)
            } else {
                queryParseMethod()
            }
        } else {
            //First time run app
            queryParseMethod()
            //Mark as first time run
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject("true", forKey: "FirstLaunch")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createActivityIndicatorView()
    }
    
    func checkUpdateFlag() -> Bool {
        let query = PFQuery(className: "UpdateFlag")
        let updateFlag:PFObject = query.getFirstObject()!
        let flag = updateFlag["Update"] as! Bool
        print(flag)
        return flag
    }
    
    func createActivityIndicatorView() {
        activityIndicatorView.center = self.view.center
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.hidden = false
        activityIndicatorView.startAnimation()
    }
    
    // Define the query that will provide the data for the table view
    func queryParseMethod() {
        print("Start query")
        let query = PFQuery(className: "Restaurant")
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) Restaurants.")
                self.objectArray = objects!
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject("\(objects!.count)", forKey: "RestaurantNum")
                PFObject.pinAllInBackground(objects, withName: "Restaurant", block: { (succeed, error) -> Void in
                    if succeed {
                        print("Pin succeffully")
                        self.activityIndicatorView.hidden = true
                        self.activityIndicatorView.stopAnimation()
                        self.deleteAllFiles()
                        self.downloadImage()
                    }
                })
            }
        }
    }
    
    func downloadImage() {
        activityIndicatorView.hidden = false
        activityIndicatorView.startAnimation()
        for var i=0; i<self.objectArray.count; i++ {
            let object:PFObject = objectArray.objectAtIndex(i) as! PFObject
            self.objectArrayToLocal.append(object)
            let objectID:String = object.objectId!
            let objectName:String = object["RestaurantName"] as! String
            let objectAddress:String = object["RestaurantAddress"] as! String
            let objectWard:String = object["RestaurantWard"] as! String
            let objectDistrict:String = object["RestaurantDistrict"] as! String
            let objectTel:String = object["RestaurantTel"] as! String
            let imageData:PFFile = object["RestaurantImage"] as! PFFile
            //Store image to local
            //var error: NSError?
            let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            let documentsDirectory: AnyObject = paths[0]
            let dataPath = documentsDirectory.stringByAppendingPathComponent("RestaurantImage")
            
            if (!NSFileManager.defaultManager().fileExistsAtPath(dataPath)) {
                do {
                    try NSFileManager.defaultManager().createDirectoryAtPath(dataPath, withIntermediateDirectories: false, attributes: nil)
                } catch _ as NSError {
                    //error = error1
                }
            }
            
            let filePathToWrite = "\(dataPath)/\(objectID)_\(objectName)_\(objectAddress)_\(objectWard)_\(objectDistrict)_\(objectTel).png"
            
            /*
            imageData.getDataInBackgroundWithBlock({ (data, error) -> Void in
                if error == nil {
                    let image = UIImage(data: data!)
                    let imageWriteData: NSData = UIImagePNGRepresentation(image!)!
                    
                    NSFileManager.defaultManager().createFileAtPath(filePathToWrite, contents: imageWriteData, attributes: nil)
                    self.activityIndicatorView.hidden = true
                    self.activityIndicatorView.stopAnimation()
                    self.performSegueWithIdentifier("MainScreenSegue", sender: nil)
                }
                
            })*/
            
            let image = UIImage(data: imageData.getData()!)
            let imageWriteData: NSData = UIImagePNGRepresentation(image!)!
            
            NSFileManager.defaultManager().createFileAtPath(filePathToWrite, contents: imageWriteData, attributes: nil)
            self.activityIndicatorView.hidden = true
            self.activityIndicatorView.stopAnimation()
            self.performSegueWithIdentifier("MainScreenSegue", sender: nil)
            
            
            
            //println(filePathToWrite)
            
            /*
            imageData.getDataInBackgroundWithBlock({ (data, error) -> Void in
                if error == nil {
                    //Store image to local
                    var error: NSError?
                    let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
                    let documentsDirectory: AnyObject = paths[0]
                    let dataPath = documentsDirectory.stringByAppendingPathComponent("RestaurantImage")
                    
                    if (!NSFileManager.defaultManager().fileExistsAtPath(dataPath)) {
                        NSFileManager.defaultManager().createDirectoryAtPath(dataPath, withIntermediateDirectories: false, attributes: nil, error: &error)
                    }
                    
                    var filePathToWrite = "\(dataPath)/\(objectName)_\(objectAddress)_\(objectWard)_\(objectDistrict)_\(objectTel).png"
                    
                    var image = UIImage(data: data!)
                    
                    var imageData: NSData = UIImagePNGRepresentation(image)
                    
                    NSFileManager.defaultManager().createFileAtPath(filePathToWrite, contents: imageData, attributes: nil)
                    
                    println(filePathToWrite)

                    /*
                    //Get file
                    var getImagePath = dataPath.stringByAppendingPathComponent("\(objectName).png")
                    
                    if (NSFileManager.defaultManager().fileExistsAtPath(getImagePath))
                    {
                        println("FILE AVAILABLE: \(getImagePath)");
                        /*
                        //Pick Image and Use accordingly
                        var imageis: UIImage = UIImage(contentsOfFile: getImagePath)!
                        
                        let data: NSData = UIImagePNGRepresentation(imageis)
                        */
                    }
                    else
                    {
                        println("FILE NOT AVAILABLE");
                        
                    }
                    
                    // or get all files
                    
                    if let directoryUrls =  NSFileManager.defaultManager().contentsOfDirectoryAtPath(dataPath, error: nil) {
                        let picFilesName = directoryUrls.map(){ $0 }.filter(){ $0.pathExtension == "png"}
                        for index in picFilesName {
                            println(index)
                        }
                    }*/
                }
            })*/
        }
    }
    
    func deleteAllFiles() {
        var _: NSError?
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory: AnyObject = paths[0]
        let dataPath = documentsDirectory.stringByAppendingPathComponent("RestaurantImage")
        
        if (NSFileManager.defaultManager().fileExistsAtPath(dataPath)) {
            if let directoryUrls = try? NSFileManager.defaultManager().contentsOfDirectoryAtPath(dataPath) {
                let picFilesName = directoryUrls.map(){ $0 }.filter(){ $0.pathExtension == "png"}
                for imageName in picFilesName {
                    let filePathToDelete = "\(dataPath)/\(imageName)"
                    do {
                        try NSFileManager.defaultManager().removeItemAtPath(filePathToDelete)
                    } catch _ {
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
