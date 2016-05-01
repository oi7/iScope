//
//  ThetaCameraViewController.swift
//  iScope
//
//  Created by 張 景隆 on 2016/5/1.
//  Copyright © 2016年 oi7. All rights reserved.
//

import UIKit

class ThetaCameraViewController: UIViewController {
    
    @IBOutlet weak var motionJpegView: UIImageView!
    
    let httpConnection = HttpConnection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
