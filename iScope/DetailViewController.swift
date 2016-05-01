//
//  AppDelegate.swift
//  iScope
//
//  Created by Poseidon Ho on 4/30/16.
//  Copyright © 2016 oi7. All rights reserved.
//

import UIKit
import Photos

class DetailViewController: UIViewController {
    var asset:PHAsset?

    @IBOutlet weak var taglistView: TagListView!
    // IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    
    // Properties
    var photo:Photo?
    
    // MARK: - Clarifai Image Tagging
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tagButton: UIBarButtonItem!
    @IBOutlet weak var overlayView: UIView!
    private lazy var client : ClarifaiClient = ClarifaiClient(appID: clarifaiClientID, appSecret: clarifaiClientSecret)
    
    @IBAction func imageTagging(sender: AnyObject) {
        if (textView.hidden == true){
            
            overlayView.hidden = false
            textView.hidden = false
            self.taglistView.hidden = false
            SwiftSpinner.show("Recognizing...")
            recognizeImage(imageView.image)
        }else{
            self.taglistView.hidden = true
            textView.hidden = true
            overlayView.hidden = true
        }
    }
    
    @IBAction func backToAlbum(sender: AnyObject) {
        if let _ = self.asset {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    private func recognizeImage(image: UIImage!) {
        // Scale down the image. This step is optional. However, sending large images over the
        // network is slow and does not significantly improve recognition performance.
        let size = CGSizeMake(320, 320 * image.size.height / image.size.width)
        UIGraphicsBeginImageContext(size)
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Encode as a JPEG.
        let jpeg = UIImageJPEGRepresentation(scaledImage, 0.9)!
        
        // Send the JPEG to Clarifai for standard image tagging.
        client.recognizeJpegs([jpeg]) {
            (results: [ClarifaiResult]?, error: NSError?) in
            
            SwiftSpinner.hide()
            
            if error != nil {
                print("Error: \(error)\n")
                self.textView.text = "Sorry, there was an error recognizing your image."
            } else {
                for tag in results![0].tags {
                    self.taglistView.addTag(tag)
                }
            }
            self.tagButton.enabled = true
        }
    }
    
    // Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.taglistView.textFont = UIFont.systemFontOfSize(18)
        self.navigationController?.navigationBarHidden = true

        if let photo = photo {
         
            imageView.image = UIImage(named: photo.imageName)
            
            title = photo.city
        }
        
        if let a = asset {
            self.imageView.image = self.getAssetImage(a)
        }

        
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {

        super.didReceiveMemoryWarning()

    }
    
    override func previewActionItems() -> [UIPreviewActionItem] {
        
        let likeAction = UIPreviewAction(title: "Like", style: .Default) { (action, viewController) -> Void in
            print("You liked the photo")
        }
        
        let deleteAction = UIPreviewAction(title: "Delete", style: .Destructive) { (action, viewController) -> Void in
            print("You deleted the photo")
        }
        
        return [likeAction, deleteAction]
        
    }
    
}
