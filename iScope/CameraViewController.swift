//
//  CameraViewController.swift
//  iScope
//
//  Created by Poseidon Ho on 4/30/16.
//  Copyright © 2016 oi7. All rights reserved.
//

import UIKit
//import CameraManager

class CameraViewController: UIViewController {
    
    // MARK: - Constants for CameraManager
    let cameraManager = CameraManager()
    // MARK: - IBOutlets for CameraManager    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var flashModeButton: UIButton!
    @IBOutlet weak var askForPermissionsButton: UIButton!
    @IBOutlet weak var askForPermissionsLabel: UILabel!
    
    static let conceptName: String? = nil
    static let conceptNamespace = "default"
    
    @IBAction func doClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - CameraManager
        cameraManager.showAccessPermissionPopupAutomatically = false
        
        askForPermissionsButton.hidden = true
        askForPermissionsLabel.hidden = true
        
        let currentCameraState = cameraManager.currentCameraStatus()
        
        if currentCameraState == .NotDetermined {
            askForPermissionsButton.hidden = false
            askForPermissionsLabel.hidden = false
        } else if (currentCameraState == .Ready) {
            addCameraToView()
        }
        if !cameraManager.hasFlash {
            flashModeButton.enabled = false
            flashModeButton.setTitle("No flash", forState: UIControlState.Normal)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.hidden = true
        self.tabBarController?.tabBar.hidden = true
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        cameraManager.resumeCaptureSession()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        cameraManager.stopCaptureSession()
    }
    
    private func addCameraToView()
    {
        cameraManager.addPreviewLayerToView(cameraView, newCameraOutputMode: CameraOutputMode.StillImage)
        cameraManager.showErrorBlock = { [weak self] (erTitle: String, erMessage: String) -> Void in
            
            let alertController = UIAlertController(title: erTitle, message: erMessage, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in  }))
            
            self?.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - @IBActions for CameraManager
    
    @IBAction func changeFlashMode(sender: UIButton)
    {
        switch (cameraManager.changeFlashMode()) {
        case .Off:
            sender.setTitle("Flash Off", forState: UIControlState.Normal)
        case .On:
            sender.setTitle("Flash On", forState: UIControlState.Normal)
        case .Auto:
            sender.setTitle("Flash Auto", forState: UIControlState.Normal)
        }
    }
    
    @IBAction func recordButtonTapped(sender: UIButton) {
        
        switch (cameraManager.cameraOutputMode) {
        case .StillImage:
            cameraManager.capturePictureWithCompletition({ (image, error) -> Void in
                let vc: ImageViewController? = self.storyboard?.instantiateViewControllerWithIdentifier("ImageVC") as? ImageViewController
                if let validVC: ImageViewController = vc {
                    if let capturedImage = image {
                        validVC.image = capturedImage
                        self.navigationController?.pushViewController(validVC, animated: true)
                    }
                }
            })
        case .VideoWithMic, .VideoOnly:
            sender.selected = !sender.selected
            sender.setTitle(" ", forState: UIControlState.Selected)
            sender.backgroundColor = sender.selected ? UIColor.redColor() : UIColor.greenColor()
            if sender.selected {
                cameraManager.startRecordingVideo()
            } else {
                cameraManager.stopRecordingVideo({ (videoURL, error) -> Void in
                    if let errorOccured = error {
                        self.cameraManager.showErrorBlock(erTitle: "Error occurred", erMessage: errorOccured.localizedDescription)
                    }
                })
            }
        }
    }
    
    @IBAction func askForCameraPermissions(sender: UIButton) {
        cameraManager.askUserForCameraPermissions({ permissionGranted in
            self.askForPermissionsButton.hidden = true
            self.askForPermissionsLabel.hidden = true
            self.askForPermissionsButton.alpha = 0
            self.askForPermissionsLabel.alpha = 0
            if permissionGranted {
                self.addCameraToView()
            }
        })
    }

}
