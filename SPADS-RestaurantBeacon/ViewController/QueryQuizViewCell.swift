//
//  QueryQuizViewCell.swift
//  SPADS-RestaurantBeacon
//
//  Created by BBaoBao on 8/17/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class QueryQuizViewCell: PFTableViewCell {
   
    @IBOutlet weak var lbQuizName: UILabel!
    @IBOutlet weak var tfQuizName: MKTextField!
    @IBOutlet weak var tfOption1: MKTextField!
    @IBOutlet weak var tfOption2: MKTextField!
    @IBOutlet weak var tfOption3: MKTextField!
    @IBOutlet weak var tfOption4: MKTextField!
    @IBOutlet weak var tfAnswer: MKTextField!
    
    var frameAdded = false
    
    class var expandableHeight: CGFloat { get {return 300}}
    class var defaultHeight: CGFloat { get {return 60}}
    
    func checkHeight() {
        tfQuizName.hidden = (frame.size.height < QueryQuizViewCell.expandableHeight)
        lbQuizName.hidden = !tfQuizName.hidden
        tfOption1.hidden = tfQuizName.hidden
        tfOption2.hidden = tfQuizName.hidden
        tfOption3.hidden = tfQuizName.hidden
        tfOption4.hidden = tfQuizName.hidden
        tfAnswer.hidden = tfQuizName.hidden
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
