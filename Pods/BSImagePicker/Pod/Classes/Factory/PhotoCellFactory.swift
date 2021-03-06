// The MIT License (MIT)
//
// Copyright (c) 2015 Joakim Gyllström
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit
import Photos

/**
Cell factory for photos
*/
final class PhotoCellFactory : CollectionViewCellFactory {
    private let photoCellIdentifier = "photoCellIdentifier"
    private let photosManager = PHCachingImageManager.defaultManager()
    
    private let imageContentMode: PHImageContentMode = .AspectFill
    
    var settings: BSImagePickerSettings?
    var imageSize: CGSize = CGSizeZero
    
    func registerCellIdentifiersForCollectionView(collectionView: UICollectionView?) {
        collectionView?.registerNib(UINib(nibName: "PhotoCell", bundle: BSImagePickerViewController.bundle), forCellWithReuseIdentifier: photoCellIdentifier)
    }
    
    func cellForIndexPath(indexPath: NSIndexPath, withDataSource dataSource: SelectableDataSource, inCollectionView collectionView: UICollectionView) -> UICollectionViewCell {
        UIView.setAnimationsEnabled(false)
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(photoCellIdentifier, forIndexPath: indexPath) as! PhotoCell
        if let settings = settings {
            cell.settings = settings
        }
        
        // Cancel any pending image requests
        if cell.tag != 0 {
            photosManager.cancelImageRequest(PHImageRequestID(cell.tag))
        }
        
        if let asset = dataSource.objectAtIndexPath(indexPath) as? PHAsset {
            cell.asset = asset
            
            // Request image
            cell.tag = Int(photosManager.requestImageForAsset(asset, targetSize: imageSize, contentMode: imageContentMode, options: nil) { (result, _) in
                cell.imageView.image = result
            })
            
            // Set selection number
            if let index = dataSource.selections.indexOf(asset) {
                if let character = settings?.selectionCharacter {
                    cell.selectionString = String(character)
                } else {
                    cell.selectionString = String(index + 1)
                }
                
                cell.selected = true
            } else {
                cell.selected = false
            }
        }
        
        UIView.setAnimationsEnabled(true)
        
        return cell
    }
}