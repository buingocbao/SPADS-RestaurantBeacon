//
//  RestaurantViewController.swift
//  SPADS-RestaurantBeacon
//
//  Created by BBaoBao on 9/3/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit
import iAd
import GoogleMobileAds

class RestaurantViewController: SAParallaxViewController {
    
    var searchContainer:UIView?
    var searchController: UISearchController?
    var data = [String]()
    var filteredData = Dictionary<String, [String]>()
    var isDataFiltered: Bool = false
    
    var tagPicker = PARTagPickerViewController()
    var chosenTags = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    var resObjectDict = Dictionary<String, [String]>()
    var resImageDict = Dictionary<String, UIImage>()
    
    //For advertise
    var adBannerView:ADBannerView?
    var isAdDisplayed = false
    var admobBannerView:GADBannerView?
    
    //Search
    var searchBarPlaceholder: UIView?
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableBannerAd()
        getImageFromLocal()
        //createSearch()
        createTagPicker()
        self.view.backgroundColor = UIColor.MKColor.Green
    }
    
    func enableBannerAd() {
        // Enable Banner Ad
        adBannerView = ADBannerView(adType: ADAdType.Banner)
        admobBannerView = GADBannerView(frame: CGRect(x: 0, y: view.bounds.height-50, width: view.bounds.width, height: 50))
        adBannerView?.delegate = self
        // Enable Interstitial Ads
        interstitialPresentationPolicy = .Manual
        UIViewController.prepareInterstitialAds()
        let timer = NSTimer(fireDate: NSDate(timeIntervalSinceNow: 30), interval: 0, target: self, selector: "displayInterstitialAds", userInfo: nil, repeats: false)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
 
    func displayInterstitialAds() {
        if displayingBannerAd {
            canDisplayBannerAds = false
        }
        requestInterstitialAdPresentation()
        canDisplayBannerAds = true
    }
    
    func getImageFromLocal() {
        //Get image from local
        resObjectDict.removeAll(keepCapacity: false)
        resImageDict.removeAll(keepCapacity: false)
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory: AnyObject = paths[0]
        let dataPath = documentsDirectory.stringByAppendingPathComponent("RestaurantImage")
        if let directoryUrls =  try? NSFileManager.defaultManager().contentsOfDirectoryAtPath(dataPath) {
            var picFilesName = directoryUrls.map(){ $0 }.filter(){ $0.pathExtension == "png"}
            picFilesName = picFilesName.shuffle()
            for index in 0...picFilesName.count-1 {
                let getImagePath = (dataPath as NSString).stringByAppendingPathComponent(picFilesName[index] )
                if (NSFileManager.defaultManager().fileExistsAtPath(getImagePath))
                {
                    print("FILE AVAILABLE: \(getImagePath)");
                    let restaurantName = picFilesName[index].stringByReplacingOccurrencesOfString(".png", withString: "", options: .LiteralSearch, range: nil)
                    var componentArray = restaurantName.characters.split {$0 == "_"}.map { String($0) }
                    print(componentArray)
                    self.resObjectDict[componentArray[0]] = [componentArray[1],componentArray[2],componentArray[3],componentArray[4],componentArray[5]]
                    print(self.resObjectDict)
                    //Pick Image and Use accordingly
                    let imageis: UIImage = UIImage(contentsOfFile: getImagePath)!
                    self.resImageDict[componentArray[0]] = imageis
                }
                else
                {
                    print("FILE NOT AVAILABLE");
                }
            }
        }
        
    }
    /*
    func createSearch() {
        //Setting UIView
        let searchContainer = UIView(frame: CGRect(x: 0, y: 54, width: self.view.bounds.width, height: 44))
        self.view.addSubview(searchContainer)
        self.searchContainer = searchContainer
        
        //Setup the search controller
        searchController = ({
            let searchController = UISearchController(searchResultsController: nil)
            searchController.searchResultsUpdater = self
            //searchController.hidesNavigationBarDuringPresentation = true
            searchController.dimsBackgroundDuringPresentation = false
            //setup the search bar
            //searchController.searchBar.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
            self.searchContainer?.addSubview(searchController.searchBar)
            self.view.bringSubviewToFront(searchContainer)
            //searchController.searchBar.sizeToFit()
            
            return searchController
        })()
    }*/
    
    func createTagPicker() {
        let tagPicker = PARTagPickerViewController()
        tagPicker.view.backgroundColor = UIColor.MKColor.Green
        tagPicker.view.frame = CGRect(x: 0, y: 54, width: self.view.bounds.width, height: 44)
        tagPicker.view.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        tagPicker.delegate = self
        tagPicker.visibilityState = PARTagPickerVisibilityState.TopOnly
        tagPicker.allTags = self.chosenTags
        self.addChildViewController(tagPicker)
        self.view.addSubview(tagPicker.view)
        self.tagPicker = tagPicker
        useCustomPicker()
    }
    
    func useCustomPicker() {
        let myColors = PARTagColorReference()
        myColors.chosenTagBorderColor = UIColor.whiteColor()
        myColors.chosenTagBackgroundColor = UIColor.MKColor.Green
        myColors.chosenTagTextColor = UIColor.whiteColor()
        
        myColors.defaultTagBorderColor = UIColor.whiteColor()
        myColors.defaultTagBackgroundColor = UIColor.MKColor.Grey
        myColors.defaultTagTextColor = UIColor.whiteColor()
        
        myColors.highlightedTagBorderColor = UIColor.whiteColor()
        myColors.highlightedTagBackgroundColor = UIColor.MKColor.Red
        myColors.highlightedTagTextColor = UIColor.whiteColor()
        
        self.tagPicker.tagColorRef = myColors
    }
    
    // MARK: Search functions
    func searchString(string: String, searchTerm:String) -> Array<AnyObject> {
        var matches:Array<AnyObject> = []
        do {
            let regex = try NSRegularExpression(pattern: searchTerm, options: [.CaseInsensitive, .AllowCommentsAndWhitespace])
            let range = NSMakeRange(0, string.characters.count)
            matches = regex.matchesInString(string, options: [], range: range)
        } catch _ {
        }
        return matches
    }
    
    func searchIsEmpty() -> Bool {
        if self.tagPicker.chosenTags.count == 0 {
            return true
        } else {
            return false
        }
    }
    /*
    func filterData() -> Dictionary<String, [String]> {
        if searchIsEmpty() {
            isDataFiltered = false
            return [:]
        } else {
            
            var filteredData = Dictionary<String, [String]>()
            for (key, array) in resObjectDict {
                let searchString = self.searchController?.searchBar.text?.lowercaseString
                let temp = array.filter { ($0 as NSString).lowercaseString.containsString(searchString!) }
                //let temp = array.filter { ($0 as NSString).lowercaseString.containsString(searchString!) }
                if temp.count != 0 {
                    filteredData[key] = array
                }
            }
            isDataFiltered = true
            print(filteredData)
            return filteredData
        }
    }
    */
    func filterDataWithTag(tags: [Character]) -> Dictionary<String, [String]> {
        if searchIsEmpty() {
            isDataFiltered = false
            return [:]
        } else {
            let object = resObjectDict
            var filteredData = Dictionary<String, [String]>()
            for character in tags {
                for i in 0...object.count-1 {
                    let resName = Array(object.values)[i][0]
                    if resName[0] == character {
                        print(resName)
                        filteredData[Array(object.keys)[i]] = Array(object.values)[i]
                    }
                }
            }
            isDataFiltered = true
            return filteredData
        }
    }
    
    func labelFont() -> UIFont {
        return UIFont.systemFontOfSize(17)
    }
}

extension RestaurantViewController {
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfRes = isDataFiltered ? filteredData.count : resObjectDict.count
        return numberOfRes
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
        
        if let cell = cell as? SAParallaxViewCell {
            
            for view in cell.containerView.accessoryView.subviews {
                if let view = view as? UILabel {
                    view.removeFromSuperview()
                }
            }
            
            let object = isDataFiltered ? filteredData : resObjectDict
            for key in object.keys {
                if key == Array(object.keys)[indexPath.row] {
                    cell.setImage(self.resImageDict[key]!)
                }
            }
            /*
            if self.resImageDict.count != 0 {
                //Pick Image and Use accordingly
                cell.setImage(Array(self.resImageDict.values)[indexPath.row])
            }*/
            
            if self.resObjectDict.count != 0 {
                let label = UILabel(frame: cell.containerView.accessoryView.bounds)
                label.textAlignment = .Center
                label.text = Array(object.values)[indexPath.row][0]
                label.textColor = .whiteColor()
                label.font = .systemFontOfSize(30)
                cell.containerView.accessoryView.addSubview(label)
            }
        }
        
        return cell
    }
}

extension RestaurantViewController {
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        super.collectionView(collectionView, didSelectItemAtIndexPath: indexPath)
        
        if let cells = collectionView.visibleCells() as? [SAParallaxViewCell] {
            let containerView = SATransitionContainerView(frame: view.bounds)
            containerView.setViews(cells: cells, view: view)
            
            let viewController = DetailViewController()
            viewController.transitioningDelegate = self
            viewController.trantisionContainerView = containerView
            
            let object = isDataFiltered ? filteredData : resObjectDict
            viewController.restaurantID = Array(object.keys)[indexPath.row]
            viewController.restaurantName = Array(object.values)[indexPath.row][0]
            let restaurantAddress = "\(Array(object.values)[indexPath.row][1]) - \(Array(object.values)[indexPath.row][2]) - \(Array(object.values)[indexPath.row][3])"
            viewController.restaurantAddress = restaurantAddress
            viewController.restaurantTel = Array(object.values)[indexPath.row][4]
            self.presentViewController(viewController, animated: true, completion: nil)
        }
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "SearchCollectionView", forIndexPath: indexPath) as! SearchCollectionReusableView
            headerView.label!.text = ""
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
}

extension RestaurantViewController: ADBannerViewDelegate, GADBannerViewDelegate {
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        print("Banner ad loaded successfully")
        isAdDisplayed = true
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        print("Failed to load banner ad")
        isAdDisplayed = false
        self.view.bringSubviewToFront(admobBannerView!)
        self.adBannerView?.removeFromSuperview()
        self.admobBannerView!.adUnitID = "ca-app-pub-1571863055327497/2083258363"
        self.admobBannerView!.rootViewController = self
        self.admobBannerView!.delegate = self
        //self.view.addSubview(admobBannerView!)
        //let request:GADRequest = GADRequest()
        //self.admobBannerView!.loadRequest(request)
    }
    
    func adView(bannerView: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        self.admobBannerView!.removeFromSuperview()
    }
}
/*
extension RestaurantViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.filteredData = filterData()
        collectionView.reloadData()
    }
}
*/
extension RestaurantViewController: PARTagPickerDelegate {
    func tagPicker(tagPicker: PARTagPickerViewController!, visibilityChangedToState state: PARTagPickerVisibilityState) {
        var newHeight:CGFloat = 0
        if state == PARTagPickerVisibilityState.TopAndBottom {
            newHeight = 2 * 44
        } else if state == PARTagPickerVisibilityState.TopOnly {
            newHeight = 44
        }
        var frame = self.tagPicker.view.frame
        frame.size.height = newHeight
        UIView.animateWithDuration(0.5) { () -> Void in
            self.tagPicker.view.frame = frame
        }
    }
    
    func chosenTagsWereUpdatedInTagPicker(tagPicker: PARTagPickerViewController!) {
        var tags = [Character]()
        for var i=0; i<tagPicker.chosenTags.count; i++ {
            tags.append(Character(tagPicker.chosenTags[i] as! String))
        }
        print(tags)
        self.filteredData = filterDataWithTag(tags)
        print(filteredData)
        print(isDataFiltered)
        collectionView.reloadData()
    }
}

extension String {
    
    var lastPathComponent: String {
        
        get {
            return (self as NSString).lastPathComponent
        }
    }
    var pathExtension: String {
        
        get {
            
            return (self as NSString).pathExtension
        }
    }
    var stringByDeletingLastPathComponent: String {
        
        get {
            
            return (self as NSString).stringByDeletingLastPathComponent
        }
    }
    var stringByDeletingPathExtension: String {
        
        get {
            
            return (self as NSString).stringByDeletingPathExtension
        }
    }
    var pathComponents: [String] {
        
        get {
            
            return (self as NSString).pathComponents
        }
    }
    
    func stringByAppendingPathComponent(path: String) -> String {
        
        let nsSt = self as NSString
        
        return nsSt.stringByAppendingPathComponent(path)
    }
    
    func stringByAppendingPathExtension(ext: String) -> String? {
        
        let nsSt = self as NSString
        
        return nsSt.stringByAppendingPathExtension(ext)
    }
    
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
}

extension CollectionType where Index == Int {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}

