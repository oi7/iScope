//
//  MapDetailViewController.swift
//  iScope
//
//  Created by 張 景隆 on 2016/5/1.
//  Copyright © 2016年 oi7. All rights reserved.
//

import UIKit
import Photos
class MapDetailViewController: UIViewController {

    var asset:PHAsset?
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let a = asset {
            self.imageView.image = self.getAssetImage(a)
        }
    }
    
    @IBAction func doClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func getAssetImage(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.defaultManager()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.synchronous = true
        
        let screenSize: CGSize = UIScreen.mainScreen().bounds.size
        let targetSize = CGSizeMake(screenSize.width, screenSize.height)
        
        manager.requestImageForAsset(asset, targetSize: targetSize, contentMode: .AspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
}
