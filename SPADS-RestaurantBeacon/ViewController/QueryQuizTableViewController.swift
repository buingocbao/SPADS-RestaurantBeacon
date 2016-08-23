//
//  QueryQuizTableViewController.swift
//  SPADS-RestaurantBeacon
//
//  Created by BBaoBao on 8/17/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class QueryQuizTableViewController: PFQueryTableViewController {

    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x:0, y: 0, width: 100, height: 100), type: NVActivityIndicatorType.BallClipRotateMultiple, color: UIColor.whiteColor(), size: CGSize(width: 100, height: 100))
    
    var selectedIndexPath: NSIndexPath?
    var allowDeleteRowAtIndexPath = false
    var editableObjects: NSMutableArray = NSMutableArray()
    
    // Initialise the PFQueryTable tableview
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init!(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Configure the PFQueryTableView
        self.parseClassName = "Quizzes"
        self.textKey = "QuizQuestion"
        self.loadingViewEnabled = false
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        //self.objectsPerPage = 20
    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        var restaurantID = ""
        if let restaurant = PFUser.currentUser()!["Restaurant"] as? String {
            restaurantID = restaurant
        }
        let query = PFQuery(className: "Quizzes").whereKey("Restaurant", equalTo: restaurantID)
        return query
    }
    
    override func objectsWillLoad() {
        // Show activityIndicatior
        self.activityIndicatorView.center = self.view.center
        self.view.addSubview(activityIndicatorView)
        self.view.bringSubviewToFront(activityIndicatorView)
        self.activityIndicatorView.startAnimation()
    }
    
    override func objectsDidLoad(error: NSError?) {
        self.activityIndicatorView.stopAnimation()
        self.activityIndicatorView.hidden = true
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("QuizQueryCell") as! QueryQuizViewCell!
        if cell == nil {
            cell = QueryQuizViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "QuizQueryCell")
        }
        
        //Config cell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        configTextFields([cell.tfQuizName:"Question",
                        cell.tfOption1:"Option1",
                        cell.tfOption2:"Option2",
                        cell.tfOption3:"Option3",
                        cell.tfOption4:"Option4",
                        cell.tfAnswer:"Answer"])
        
        // Extract values from the PFObject to display in the table cell
        
        if let quizName = object?["QuizQuestion"] as? String {
            cell.lbQuizName.text = quizName
            cell.tfQuizName.text = quizName
        }
        
        if let option1 = object?["Option1"] as? String {
            cell.tfOption1.text = option1
        }
        
        if let option2 = object?["Option2"] as? String {
            cell.tfOption2.text = option2
        }
        
        if let option3 = object?["Option3"] as? String {
            cell.tfOption3.text = option3
        }
        if let option4 = object?["Option4"] as? String {
            cell.tfOption4.text = option4
        }
        
        if let quizAnswer = object?["Answer"] as? String {
            cell.tfAnswer.text = quizAnswer
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let previousIndexPath = selectedIndexPath
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
        
        var indexPaths : Array<NSIndexPath> = []
        if let previous = previousIndexPath {
            indexPaths += [previous]
        }
        
        if let current = selectedIndexPath {
            indexPaths += [current]
        }
        
        if indexPaths.count > 0 {
            tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath == selectedIndexPath {
            return QueryQuizViewCell.expandableHeight
        } else {
            return QueryQuizViewCell.defaultHeight
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! QueryQuizViewCell).watchFrameChanges()
        cell.separatorInset = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
    }
    
    override func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! QueryQuizViewCell).ignoreFrameChanges()
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            showAlertForDeleting(indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        // 1
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Update" , handler: { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
            print("Edit Touched")
            self.activityIndicatorView.startAnimation()
            self.activityIndicatorView.hidden = false
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! QueryQuizViewCell
            let object:PFObject = self.objectAtIndexPath(indexPath)!
            object["QuizQuestion"] = cell.tfQuizName.text
            object["Option1"] = cell.tfOption1.text
            object["Option2"] = cell.tfOption2.text
            object["Option3"] = cell.tfOption3.text
            object["Option4"] = cell.tfOption4.text
            object["Answer"] = cell.tfAnswer.text
            object.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
                if succeeded {
                    self.activityIndicatorView.stopAnimation()
                    self.activityIndicatorView.hidden = true
                    let successAlertViewController:NYAlertViewController = NYAlertViewController()
                    successAlertViewController.addAction(NYAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }))
                    successAlertViewController.title = "Successful"
                    successAlertViewController.message = "You successfully updated quiz!"
                    successAlertViewController.titleColor = UIColor.MKColor.Orange
                    successAlertViewController.buttonColor = UIColor.MKColor.Green
                    successAlertViewController.buttonTitleColor = UIColor(white: 0.19, alpha: 1.0)
                    self.presentViewController(successAlertViewController, animated: true, completion: nil)
                    self.loadObjects()
                    self.tableView.reloadData()
                }
            })
        })
        
        editAction.backgroundColor = UIColor.MKColor.Blue
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler: { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
            self.showAlertForDeleting(indexPath)
        })
        
        return [deleteAction, editAction]
    }
    
    func showAlertForDeleting(indexPath: NSIndexPath) {
        let alertVC:NYAlertViewController = NYAlertViewController(nibName: nil, bundle: nil)
        alertVC.backgroundTapDismissalGestureEnabled = false
        alertVC.swipeDismissalGestureEnabled = true
        alertVC.title = "Confirm"
        alertVC.message = "Are you sure for deleting this quiz?"
        alertVC.buttonCornerRadius = 20.0
        alertVC.view.tintColor = self.view.tintColor
        alertVC.titleFont = UIFont(name: "AvenirNext-Bold", size: 18.0)
        alertVC.messageFont = UIFont(name: "AvenirNext-Medium", size: 16.0)
        alertVC.buttonTitleFont = UIFont(name: "AvenirNext-Regular", size: alertVC.buttonTitleFont.pointSize)
        alertVC.cancelButtonTitleFont = UIFont(name: "AvenirNext-Medium", size: alertVC.cancelButtonTitleFont.pointSize)
        alertVC.alertViewBackgroundColor = UIColor(white: 0.19, alpha: 1.0)
        alertVC.alertViewCornerRadius = 10.0
        alertVC.titleColor = UIColor.MKColor.Orange
        alertVC.messageColor = UIColor.whiteColor()
        alertVC.buttonColor = UIColor.MKColor.Red
        alertVC.buttonTitleColor = UIColor(white: 0.19, alpha: 1.0)
        alertVC.cancelButtonColor = UIColor.MKColor.Green
        alertVC.cancelButtonTitleColor = UIColor(white: 0.19, alpha: 1.0)
        alertVC.addAction(NYAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            //OK action
            self.dismissViewControllerAnimated(true, completion: {
                let object:PFObject = self.objectAtIndexPath(indexPath)!
                object.deleteInBackgroundWithBlock({ (succeeded, error) -> Void in
                    if succeeded {
                        self.loadObjects()
                        self.tableView.reloadData()
                    }
                })
            })
        }))
        alertVC.addAction(NYAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
            //Cancel action
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alertVC, animated: true, completion: nil)
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        /*
        // Get the new view controller using [segue destinationViewController].
        var detailScene = segue.destinationViewController as! AddPromotionViewController
        
        // Pass the selected object to the destination view controller.
        if let indexPath = self.tableView.indexPathForSelectedRow() {
        let row = Int(indexPath.row)
        detailScene.currentObject = (objects?[row] as! PFObject)
        }
        */
        if (segue.identifier == "EditPromotionSegue") {
            let addPromotionView:AddPromotionViewController = segue.destinationViewController as! AddPromotionViewController
            addPromotionView.lbMainText = "Edit Promotion"
            addPromotionView.currentObject = sender as? PFObject
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        // Refresh the table to ensure any data changes are displayed
        tableView.reloadData()
    }
    
    func configTextFields(textFields: Dictionary<MKTextField,String>) {
        for (textField,placeHolder) in textFields {
            // No border, no shadow, floatingPlaceholderEnabled
            textField.layer.borderColor = UIColor.clearColor().CGColor
            textField.floatingPlaceholderEnabled = true
            textField.placeholder = placeHolder
            textField.tintColor = UIColor.whiteColor()
            textField.textColor = UIColor.whiteColor()
            textField.rippleLocation = .Right
            textField.cornerRadius = 0
            textField.bottomBorderEnabled = true
        }
    }
}
