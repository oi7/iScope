//
//  PresentCameraViewController.swift
//  iScope
//
//  Created by 張 景隆 on 2016/5/1.
//  Copyright © 2016年 oi7. All rights reserved.
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
