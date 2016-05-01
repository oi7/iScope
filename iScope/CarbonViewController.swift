//
//  CarbonViewController.swift
//  iScope
//
//  Created by Poseidon Ho on 4/30/16.
//  Copyright © 2016 oi7. All rights reserved.
//

import UIKit

extension CarbonViewController: CarbonTabSwipeNavigationDelegate {
    func carbonTabSwipeNavigation(carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAtIndex index: UInt) -> UIViewController {
        
                switch index {
                case 0:
                    return self.storyboard!.instantiateViewControllerWithIdentifier("MicroscopeViewController")
                case 1:
                    return self.storyboard!.instantiateViewControllerWithIdentifier("SpheroscopeViewController")
                case 2:
                    return self.storyboard!.instantiateViewControllerWithIdentifier("TelescopeViewController")
                default:
                    return UIViewController()
                }
        
    }
    
    func carbonTabSwipeNavigation(carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAtIndex index: UInt) {
        NSLog("Did move at index: %ld", index)
    }
}

class CarbonViewController: UIViewController {
    
    var items = ["Microscope", "Spheroscope", "Telescope"]
    var carbonTabSwipeNavigation: CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        self.title = "iScope"
//
        //        items = [UIImage(named: "home")!, UIImage(named: "hourglass")!, UIImage(named: "premium_badge")!, "Categories", "Top Free", "Top New Free", "Top Paid", "Top New Paid"]
        carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items as [AnyObject], delegate: self)
        carbonTabSwipeNavigation.insertIntoRootViewController(self)
//        self.style()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.hidden = true
        self.tabBarController?.tabBar.hidden = true
    }
    
    func style() {
        var color: UIColor = UIColor(red: 24.0 / 255, green: 75.0 / 255, blue: 152.0 / 255, alpha: 1)
        self.navigationController!.navigationBar.translucent = false
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.barTintColor = color
        self.navigationController!.navigationBar.barStyle = .BlackTranslucent
        carbonTabSwipeNavigation.toolbar.translucent = false
        carbonTabSwipeNavigation.setIndicatorColor(color)
        carbonTabSwipeNavigation.setTabExtraWidth(30)
        carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(80, forSegmentAtIndex: 0)
        carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(80, forSegmentAtIndex: 1)
        carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(80, forSegmentAtIndex: 2)
        
        carbonTabSwipeNavigation.setNormalColor(UIColor.blackColor().colorWithAlphaComponent(0.6))
        carbonTabSwipeNavigation.setSelectedColor(color, font: UIFont.boldSystemFontOfSize(14))
        
    }

    
}
