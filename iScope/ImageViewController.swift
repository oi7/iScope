//
//  ImageViewController.swift
//  iScope
//
//  Created by Poseidon Ho on 5/1/16.
//  Copyright © 2016 oi7. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    @IBOutlet weak var taglistView: TagListView!
    
    var image: UIImage?
    private lazy var client : ClarifaiClient =
        ClarifaiClient(appID: clarifaiClientID, appSecret: clarifaiClientSecret)
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var retakeButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var overlayView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBar.hidden = true
        overlayView.hidden = false
        if let validImage = self.image {
            self.imageView.image = validImage
        }

        textView.text = "Recognizing..."
        recognizeImage(image)

        
        taglistView.addTag("AAA")
        taglistView.addTag("BBB")
    }
    
    @IBAction func backToAlbum(sender: UIButton) {
        tabBarController?.selectedIndex = 0
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func backToCamera(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func shareButton(sender: UIButton) {
        let image = generateImage()
        
        let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        activity.completionWithItemsHandler = { (activityType: String?, completed: Bool, returnedItems: [AnyObject]?, activityError: NSError?) -> Void in
            if completed {
                activity.dismissViewControllerAnimated(true, completion: nil)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        presentViewController(activity, animated: true, completion: nil)
    }
    
    func generateImage() -> UIImage {
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    private func recognizeImage(image: UIImage!) {
        textView.hidden = false
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
            if error != nil {
                print("Error: \(error)\n")
                self.textView.text = "Sorry, there was an error recognizing your image."
            } else {
                self.textView.text = results![0].tags.joinWithSeparator(", ")
            }
            //            self.tagButton.enabled = true
        }
    }

    

}
