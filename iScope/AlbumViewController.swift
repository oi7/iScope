//
//  AlbumViewController.swift
//  iScope
//
//  Created by Poseidon Ho on 4/30/16.
//  Copyright © 2016 oi7. All rights reserved.
//

import UIKit
//import SKPhotoBrowser

private let reuseIdentifier = "photoCell"

class AlbumViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, SKPhotoBrowserDelegate, UIViewControllerPreviewingDelegate {
    
    // MARK: - SKPhotoBrowser
    
    private final let screenBound = UIScreen.mainScreen().bounds
    private var screenWidth: CGFloat { return screenBound.size.width }
    private var screenHeight: CGFloat { return screenBound.size.height }
    
    @IBOutlet weak var collectionView: UICollectionView!
    var images = [SKPhotoProtocol]()
    var caption = ["1",
                   "2",
                   "3",
                   "4",
                   "5",
                   "6",
                   "7",
                   "8",
                   "9",
                   "10",
                   "11",
                   "12",
                   ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if( traitCollection.forceTouchCapability == .Available){
            registerForPreviewingWithDelegate(self, sourceView: view)
            
        }
        
        for i in 0..<10 {
            let photo = SKPhoto.photoWithImage(UIImage(named: "image\(i%10).jpg")!)
            if i == 0 {
                // MARK: [BUG] this image can't be cached!!!
                photo.photoURL = "https://images.unsplash.com/photo-1451906278231-17b8ff0a8880?crop=entropy&dpr=2&fit=crop&fm=jpg&h=800&ixjsv=2.1.0&ixlib=rb-0.3.5&q=50&w=1275"
            }
            if i == 1 {
                photo.photoURL = "https://images.unsplash.com/photo-1458640904116-093b74971de9?crop=entropy&dpr=2&fit=crop&fm=jpg&h=800&ixjsv=2.1.0&ixlib=rb-0.3.5&q=50&w=1275"
            }
            photo.caption = caption[i%10]
            images.append(photo)
        }
        
        setupTableView()
    }
    
    private func setupTableView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier("exampleCollectionViewCell", forIndexPath: indexPath) as? ExampleCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.exampleImageView.image = images[indexPath.row].underlyingImage
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? ExampleCollectionViewCell else {
            return
        }
        guard let originImage = cell.exampleImageView.image else {
            return
        }
        let browser = SKPhotoBrowser(originImage: originImage, photos: images, animatedFromView: cell)
        browser.initializePageIndex(indexPath.row)
        browser.delegate = self
        browser.displayDeleteButton = true
        browser.statusBarStyle = .LightContent
        browser.bounceAnimation = true
        
        // Can hide the action button by setting to false
        browser.displayAction = true
        
        // delete action(you must write `removePhoto` delegate, what resource you want to delete)
        // browser.displayDeleteButton = true
        
        // Optional action button titles (if left off, it uses activity controller
        // browser.actionButtonTitles = ["Do One Action", "Do Another Action"]
        
        presentViewController(browser, animated: true, completion: {})
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            return CGSize(width: screenWidth/2 - 5, height: 300)
        } else {
            return CGSize(width: screenWidth/2 - 5, height: 200)
        }
    }
    
    // MARK: - SKPhotoBrowserDelegate
    func didShowPhotoAtIndex(index: Int) {
        collectionView.visibleCells().forEach({$0.hidden = false})
        collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0))?.hidden = true
    }
    
    func willDismissAtPageIndex(index: Int) {
        collectionView.visibleCells().forEach({$0.hidden = false})
        collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0))?.hidden = true
    }
    
    func willShowActionSheet(photoIndex: Int) {
        // do some handle if you need
    }
    
    func didDismissAtPageIndex(index: Int) {
        collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0))?.hidden = false
    }
    
    func didDismissActionSheetWithButtonIndex(buttonIndex: Int, photoIndex: Int) {
        // handle dismissing custom actions
    }
    
    func removePhoto(browser: SKPhotoBrowser, index: Int, reload: (() -> Void)) {
        reload()
    }
    
    func viewForPhoto(browser: SKPhotoBrowser, index: Int) -> UIView? {
        
        return collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0))
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: - Implementations of Peek and Pop
    
    // Properties
    lazy var photos:[Photo] = {
        
        return [
            Photo(caption: "Lovely piece of art in Bordeaux", imageName: "bordeaux", city: "Bordeaux"),
            Photo(caption: "Cosy lake beach in France", imageName: "lake", city: "Bordeaux"),
            Photo(caption: "Harbour in France", imageName: "harbour", city: "Rouffiac"),
            Photo(caption: "Buda beach in Kortrijk", imageName: "buda", city: "Kortrijk")
        ]
        
    }()
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if( segue.identifier == "sgPhotoDetail" ){
            
            let photo = photos[(collectionView?.indexPathsForSelectedItems()![0].row)!]
            
            let vc = segue.destinationViewController as! DetailViewController
            vc.photo = photo
            
        }
        
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
        
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photos.count
        
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PhotoCollectionViewCell
        
        // Configure the cell
        let photo = photos[indexPath.row]
        
        if let image = UIImage(named: photo.imageName) {
            
            cell.imageView.image = image
            
        }else {
            
            cell.imageView.image = UIImage(named: "image-not-found")
            
        }
        
        return cell
    }
    
    // MARK: Trait collection delegate methods
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = collectionView?.indexPathForItemAtPoint(location) else { return nil }
        
        guard let cell = collectionView?.cellForItemAtIndexPath(indexPath) else { return nil }
        
        guard let detailVC = storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as? DetailViewController else { return nil }
        
        let photo = photos[indexPath.row]
        detailVC.photo = photo
        
        detailVC.preferredContentSize = CGSize(width: 0.0, height: 300)
        
        previewingContext.sourceRect = cell.frame
        
        return detailVC
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        
        showViewController(viewControllerToCommit, sender: self)
        
    }
}