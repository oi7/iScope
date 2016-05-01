//
//  SpheroscopeViewController.swift
//  iScope
//
//  Created by Poseidon Ho on 4/30/16.
//  Copyright © 2016 oi7. All rights reserved.
//

import UIKit
import AssetsLibrary

class SpheroscopeViewController: UIViewController {
    
    @IBOutlet weak var motionJpegView: UIImageView!
    
    let httpConnection = HttpConnection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        httpConnection.setTargetIp("192.168.1.1")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        connect()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        disconnect()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func disconnect() {
        httpConnection.close { 
            //
        }
    }
    
    func connect() {
        httpConnection.connect { (connected) in
            if connected {
                self.httpConnection.startLiveView({ (frameData) in
                    //
                    if let image = UIImage(data: frameData) {
                        self.motionJpegView.image = image
                    }
                })
            }
        }
    }
    
    @IBAction func doConnect(sender: AnyObject) {
        httpConnection.connect { (connected) in
            if connected {
                self.httpConnection.startLiveView({ (frameData) in
                    //
                    if let image = UIImage(data: frameData) {
                        self.motionJpegView.image = image
                    }
                })
            }
        }
    }
}
