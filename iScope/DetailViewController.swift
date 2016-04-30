//
//  AppDelegate.swift
//  iScope
//
//  Created by Poseidon Ho on 4/30/16.
//  Copyright © 2016 oi7. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UINavigationControllerDelegate {

    // IBOutlets
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    // Properties
    var photo:Photo?
    
    // MARK: - Clarifai Image Tagging
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var button: UIButton!
    
    private lazy var client : ClarifaiClient = ClarifaiClient(appID: clarifaiClientID, appSecret: clarifaiClientSecret)
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // The user picked an image. Send it to Clarifai for recognition.
            exampleImageView.image = image
            textView.text = "Recognizing..."
            button.enabled = false
            recognizeImage(image)
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
            if error != nil {
                print("Error: \(error)\n")
                self.textView.text = "Sorry, there was an error recognizing your image."
            } else {
                self.textView.text = "Tags:\n" + results![0].tags.joinWithSeparator(", ")
            }
            self.button.enabled = true
        }
    }
    
    // Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        if let photo = photo {
         
            imageView.image = UIImage(named: photo.imageName)
            captionLabel.text = photo.caption
            
            title = photo.city
        }
        
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
