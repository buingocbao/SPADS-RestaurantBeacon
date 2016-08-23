//
//  ThumbnailCollectionViewCell.swift
//  SPADS-RestaurantBeacon
//
//  Created by BBaoBao on 8/10/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class ThumbnailCollectionViewCell: UICollectionViewCell {
    // Estimate Size if there is diffirent size
    var featureImageSizeOptional:CGSize?
    // Async
    var placeholderLayer: CALayer!
    var contentLayer: CALayer?
    var containerNode: ASDisplayNode?
    var nodeConstructionOperation: NSOperation?
    // Async
    override func awakeFromNib() {
        super.awakeFromNib()
        //Async
        placeholderLayer = CALayer()
        placeholderLayer.contents = UIImage(named: "DefaultProduct")!.CGImage
        placeholderLayer.contentsGravity = kCAGravityCenter
        placeholderLayer.contentsScale = UIScreen.mainScreen().scale
        placeholderLayer.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 1, alpha: 1).CGColor
        contentView.layer.addSublayer(placeholderLayer)
        //Asyns
    }
    
    //MARK: Layout
    override func sizeThatFits(size: CGSize) -> CGSize {
        if let featureImageSize = featureImageSizeOptional {
            return FrameCalculator.sizeThatFits(size, withImageSize: featureImageSize)
        } else {
            return CGSizeZero
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //Async
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        placeholderLayer?.frame = bounds
        CATransaction.commit()
        //Async
    }
    
    //MARK: Cell reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        //Async
        if let operation = nodeConstructionOperation {
            operation.cancel()
        }
        containerNode?.recursivelySetDisplaySuspended(true)
        contentLayer?.removeFromSuperlayer()
        contentLayer = nil
        containerNode = nil
        //Async
    }
    
    //MARK: Cell Content
    func configureCellDisplayWithDrinkInfo(drinkObject: PFObject, data: NSData, nodeConstructionQueue: NSOperationQueue) {
        if let oldNodeConstructionOperation = nodeConstructionOperation {
            oldNodeConstructionOperation.cancel()
        }
        //MARK: Image Size Section
        let image:UIImage = UIImage(data: data)!
        featureImageSizeOptional = image.size
        
        let newNodeConstructionOperation = nodeConstructionOperationWithDrinkInfo(drinkObject, image: image)
        nodeConstructionOperation = newNodeConstructionOperation
        nodeConstructionQueue.addOperation(newNodeConstructionOperation)
        //Async
        
    }
    
    func nodeConstructionOperationWithDrinkInfo(drinkObject: PFObject, image: UIImage) -> NSOperation {
        let nodeConstructionOperation = NSBlockOperation()
        nodeConstructionOperation.addExecutionBlock {
            [weak self, unowned nodeConstructionOperation] in
            if nodeConstructionOperation.cancelled {
                return
            }
            if let strongSelf = self {
                //Async
                ///MARK: Node Creation Section
                let backgroundImageNode = ASImageNode()
                backgroundImageNode.image = image
                backgroundImageNode.contentMode = .ScaleAspectFit
                backgroundImageNode.layerBacked = true
                backgroundImageNode.imageModificationBlock = { input in
                    if input == nil {
                        return input
                    }
                    
                    let didCancelBlur: () -> Bool = {
                        var isCancelled = true
                        // 1
                        if let strongBackgroundImageNode = backgroundImageNode {
                            // 2
                            let isCancelledClosure = {
                                isCancelled = strongBackgroundImageNode.displaySuspended
                            }
                            
                            // 3
                            if NSThread.isMainThread() {
                                isCancelledClosure()
                            } else {
                                dispatch_sync(dispatch_get_main_queue(), isCancelledClosure)
                            }
                        }
                        return isCancelled
                    }
                    
                    if let blurredImage = input.applyBlurWithRadius(
                        30,
                        tintColor: UIColor(white: 0.5, alpha: 0.3),
                        saturationDeltaFactor: 1.8,
                        maskImage: nil,
                        didCancel:didCancelBlur) {
                            return blurredImage
                    } else {
                        return image
                    }
                }
                let featureImageNode = ASImageNode()
                featureImageNode.layerBacked = true
                featureImageNode.contentMode = UIViewContentMode.ScaleAspectFit
                featureImageNode.image = image
                let titleTextNode = ASTextNode()
                titleTextNode.layerBacked = true
                titleTextNode.backgroundColor = UIColor.clearColor()
                let productName = drinkObject["ProductName"] as! String
                let productPrice = drinkObject["ProductPrice"] as! String
                titleTextNode.attributedString = NSAttributedString.attributedStringForTitleText("\(productName) - \(productPrice)")
                let gradientNode = GradientNode()
                gradientNode.opaque = false
                gradientNode.layerBacked = true
                
                //MARK: Container Node Creation Section
                let containerNode = ASDisplayNode()
                //let containerNode = ASDisplayNode(layerClass: AnimatedContentsDisplayLayer.self)
                //let containerNode = ASDisplayNode(layerBlock: <#ASDisplayNodeLayerBlock!##() -> CALayer!#>)
                containerNode.layerBacked = true
                containerNode.shouldRasterizeDescendants = true
                containerNode.borderColor = UIColor(hue: 0, saturation: 0, brightness: 0.85, alpha: 0.2).CGColor
                containerNode.borderWidth = 1
                
                //MARK: Node Hierarchy Section
                //containerNode.addSubnode(backgroundImageNode)
                containerNode.addSubnode(featureImageNode)
                //containerNode.addSubnode(gradientNode)
                //containerNode.addSubnode(titleTextNode)
                
                
                //MARK: Node Layout Section
                containerNode.frame = FrameCalculator.frameForContainer(featureImageSize: image.size)
                backgroundImageNode.frame = FrameCalculator.frameForBackgroundImage(containerBounds:containerNode.bounds)
                featureImageNode.frame = FrameCalculator.frameForFeatureImage(featureImageSize: image.size,containerFrameWidth: containerNode.frame.size.width)
                gradientNode.frame = FrameCalculator.frameForGradient(
                    featureImageFrame: featureImageNode.frame)
                titleTextNode.frame = FrameCalculator.frameForTitleText(
                    containerBounds: containerNode.bounds,
                    featureImageFrame: featureImageNode.frame)
                // 1
                dispatch_async(dispatch_get_main_queue()) { [weak nodeConstructionOperation] in
                    if let strongNodeConstructionOperation = nodeConstructionOperation {
                        // 2
                        if strongNodeConstructionOperation.cancelled {
                            return
                        }
                        
                        // 3
                        if strongSelf.nodeConstructionOperation !== strongNodeConstructionOperation {
                            return
                        }
                        
                        // 4
                        if containerNode.displaySuspended {
                            return
                        }
                        
                        // 5
                        //MARK: Node Layer and Wrap Up Section
                        strongSelf.contentView.layer.addSublayer(containerNode.layer)
                        containerNode.setNeedsDisplay()
                        strongSelf.contentLayer = containerNode.layer
                        strongSelf.containerNode = containerNode
                    }
                }
            }
        }
        return nodeConstructionOperation
    }
}
