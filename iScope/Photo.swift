//
//  AppDelegate.swift
//  iScope
//
//  Created by Poseidon Ho on 4/30/16.
//  Copyright © 2016 oi7. All rights reserved.
//

import UIKit

struct Photo {

    let caption:String
    let imageName:String
    let city:String
    
    init(caption:String, imageName:String, city:String){
        
        self.caption = caption
        self.imageName = imageName
        self.city = city
        
    }
    
}
