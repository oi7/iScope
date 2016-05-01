//
//  PresentCameraViewController.swift
//  iScope
//
//  Created by Poseidon Ho on 4/30/16.
//  Copyright © 2016 oi7. All rights reserved.
//

import UIKit

class PresentCameraViewController: UIViewController {

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("CarbonViewControllerNav")
        
        self.tabBarController?.presentViewController(vc!, animated: true) {
            self.tabBarController?.selectedIndex = 0
        }
    }
}
