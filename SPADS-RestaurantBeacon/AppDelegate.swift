//
//  AppDelegate.swift
//  SPADS-RestaurantBeacon
//
//  Created by BBaoBao on 8/5/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit
import CoreLocation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var beaconRegion: CLBeaconRegion!
    var locationManager: CLLocationManager!
    var isSearchingForBeacons = false
    var lastFoundBeacon: CLBeacon! = CLBeacon()
    var lastProximity: CLProximity! = CLProximity.Unknown
    var beacons = []

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        /*
        // Check first time run app
        if (!NSUserDefaults.standardUserDefaults().boolForKey("HasLauchedOnce")) {
            //NSUserDefaults.standardUserDefaults().setBool(true, forKey: "HasLauchedOnce")
            //setInitialViewController("LoadingVC")
        } else {
            //setInitialViewController("CentreVC")
        }*/
        
        // Parse key
        Parse.enableLocalDatastore()
        Parse.setApplicationId("v79DOVFsC146SW2GPn0mX1rUEFuMiWUMInEzUBKx", clientKey:"mwO4bb3SaKnDrzU21c6Val28KDmX6Dv1D3FXMBhk")
        
        // MARK: Beacon settings
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        let uuid = NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")
        //beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 3157, identifier: "www.spads.jp")
        beaconRegion = CLBeaconRegion(proximityUUID: uuid!, major: 50258, minor: 63716, identifier: "www.spads.jp")
        
        locationManager = CLLocationManager()
        if ((locationManager?.respondsToSelector("requestAlwaysAuthorization")) != nil) {
            locationManager?.requestAlwaysAuthorization()
        }
        locationManager?.delegate = self
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.startMonitoringForRegion(beaconRegion)
        locationManager?.startRangingBeaconsInRegion(beaconRegion)
        locationManager?.startUpdatingLocation()
        
        if(application.respondsToSelector("registerUserNotificationSettings:")) {
            application.registerUserNotificationSettings(
                UIUserNotificationSettings(
                    forTypes: [UIUserNotificationType.Alert, UIUserNotificationType.Sound, UIUserNotificationType.Badge],
                    categories: nil
                )
            )
        }
        
        // Push
        application.registerForRemoteNotifications()

        return true
    }
    
    func setInitialViewController(viewControllerName: String) {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let initialViewController = storyboard.instantiateViewControllerWithIdentifier(viewControllerName) 
        
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.channels = ["global"]
        currentInstallation.saveInBackground()
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
    }
}

extension AppDelegate: CLLocationManagerDelegate {
    
    // MARK: Query Parse for Notification
    func queryParseMethodforPushNoti(state: String) {
        
        let notification:UILocalNotification = UILocalNotification()
        
        //println("Start query")
        let query = PFQuery(className: "Notification")
        query.getObjectInBackgroundWithId("YCZRGN8fj7", block: { (object, error) -> Void in
            //Success retrieved
            if error == nil {
                //println("Successfully retrieved object: \(object)")
                if let notication = object {
                    switch state {
                    case "Enter":
                        //Enter notification
                        notification.alertBody = notication["EnterRegion"] as? String
                        notification.soundName = "NotificationSound.m4a"
                        UIApplication.sharedApplication().scheduleLocalNotification(notification)
                    case "Exit":
                        //Exit notification
                        notification.alertBody = notication["ExitRegion"] as? String
                        notification.soundName = "NotificationSound.m4a"
                        UIApplication.sharedApplication().scheduleLocalNotification(notification)
                    default:
                        break
                    }
                }
            } else {
                print("Failed to retrieve object. Push default string")
                /*
                switch state {
                case "Enter":
                    //Enter notification
                    notification.alertBody = "Welcome"
                    notification.soundName = "NotificationSound.m4a"
                    UIApplication.sharedApplication().scheduleLocalNotification(notification)
                case "Exit":
                    //Exit notification
                    notification.alertBody = "Goodbye"
                    notification.soundName = "NotificationSound.m4a"
                    UIApplication.sharedApplication().scheduleLocalNotification(notification)
                default:
                    break
                }*/

            }
        })
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        //println("didRangeBeacons")
        var message:String = ""
        if beacons.count > 0 {
            let nearestBeacon:CLBeacon = beacons[0] 
            if(nearestBeacon.proximity == lastProximity ||
                nearestBeacon.proximity == CLProximity.Unknown) {
                    return;
            }
            lastProximity = nearestBeacon.proximity;
            switch nearestBeacon.proximity {
            case CLProximity.Far:
                message = "You are outside the restaurant (Far away)"
            case CLProximity.Near:
                message = "You are in front of the restaurant (Far)"
            case CLProximity.Immediate:
                message = "You are inside the restaurant (Immediate)"
            case CLProximity.Unknown:
                return
            }
        } else {
            //message = "No beacon are nearby"
        }
        
        self.beacons = beacons
        
        //Update beacons in range through many view controllers
        NSNotificationCenter.defaultCenter().postNotificationName("updateBeaconTableView", object: self.beacons)
        print(message)

    }
    
    // MARK: Start Monitoring For Region
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        locationManager.requestStateForRegion(region)
    }
    
    // MARK: Determine State
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        if state == CLRegionState.Inside {
            locationManager.startRangingBeaconsInRegion(beaconRegion)
        }
        else {
            locationManager.stopRangingBeaconsInRegion(beaconRegion)
        }
    }
    
    // MARK: Enter Region
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        manager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
        manager.startUpdatingLocation()
        
        print("You entered the region")
        
        if IJReachability.isConnectedToNetwork() {
            queryParseMethodforPushNoti("Enter")
        } else {
            let notification:UILocalNotification = UILocalNotification()
            //Enter notification
            notification.alertBody = "Welcome. It seems like you don't connect to Internet."
            notification.soundName = "NotificationSound.m4a"
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
    }
    
    // MARK: Exit Region
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        manager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
        manager.stopUpdatingLocation()
        
        print("You exited the region")
        
        if IJReachability.isConnectedToNetwork() {
            queryParseMethodforPushNoti("Exit")
        } else {
            let notification:UILocalNotification = UILocalNotification()
            //Exit notification
            notification.alertBody = "Goodbye"
            notification.soundName = "NotificationSound.m4a"
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
    }
    
}


