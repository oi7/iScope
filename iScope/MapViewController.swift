//
//  MapViewController.swift
//  iScope
//
//  Created by Poseidon Ho on 4/30/16.
//  Copyright © 2016 oi7. All rights reserved.
//

import UIKit
import Photos
import MapKit
import QuartzCore

extension MapViewController : PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(changeInstance: PHChange) {
        dispatch_async(dispatch_get_main_queue(), {
            self.loadImage()
        })
        
    }
}

extension MapViewController:MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        //
        let annotationView = MKAnnotationView()
        if let title = annotation.title, a = self.photoDict[title!] {
            let image = self.getAssetThumbnail(a)
            annotationView.image = image.circle
        }
        annotationView.canShowCallout = false
        return annotationView
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        //
        print("didSelectAnnotationView")
        mapView.deselectAnnotation(view.annotation, animated: false)
        
        if let photoAnnotation = view.annotation as? PhotoAnnotation {
//            print(photoAnnotation.asset)
            
//            self.performSegueWithIdentifier("toMapDetail", sender: photoAnnotation.asset)
            
            if let detailView = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as? DetailViewController {
                detailView.asset = photoAnnotation.asset
                
                self.presentViewController(detailView, animated: true, completion: nil)
            }
        }
    }
}

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var photoDict = [String:PHAsset]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
    }
    
//    init() {
//        super.init()
//        // here I do some other stuff
//        PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loadImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toMapDetail" {
            if let mapDetail = segue.destinationViewController as? MapDetailViewController {
                if let a = sender as? PHAsset {
                    mapDetail.asset = a
                }
            }
        }
    }
    
    func loadImage() {
        // clean annotaions
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let assets: PHFetchResult = PHAsset.fetchAssetsWithMediaType(.Image, options: options)
        assets.enumerateObjectsUsingBlock { (asset, _, _) in
            
            if let a = asset as? PHAsset {
                print(a.location)
                
                guard let coo = a.location?.coordinate else { return }
                
                let photoAnnotation = PhotoAnnotation()
                photoAnnotation.asset = a
                photoAnnotation.coordinate = coo
                photoAnnotation.title = "\(a.creationDate!.timeIntervalSince1970)"
                self.photoDict["\(a.creationDate!.timeIntervalSince1970)"] = a
                
                self.mapView.addAnnotation(photoAnnotation)
            }
        }
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.defaultManager()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.synchronous = true
        manager.requestImageForAsset(asset, targetSize: CGSize(width: 100.0, height: 100.0), contentMode: .AspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIImage {
    var rounded: UIImage? {
        let imageView = UIImageView(image: self)
        imageView.layer.cornerRadius = min(size.height/2, size.width/2)
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContext(imageView.bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.renderInContext(context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    var circle: UIImage? {
        let square = CGSize(width: min(size.width, size.height), height: min(size.width, size.height))
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        imageView.contentMode = .ScaleAspectFill
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContext(imageView.bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.renderInContext(context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
