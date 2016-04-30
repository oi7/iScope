//
//  ClarifaiCredentials.swift
//  iScope
//
//  Created by Poseidon Ho on 4/30/16.
//  Copyright © 2016 oi7. All rights reserved.
//

import Foundation;

let clarifaiClientID = "ToBB-_J3oFXY-jFs6PMkXVW7Oc8uXPYdh8b358LQ"
let clarifaiClientSecret = "ZjZZJNutJxpHBgsP7csgY7IqKctyoBAEdGAEnhyz"

@objc class Credentials : NSObject {
    class func clientID() -> String { return clarifaiClientID }
    class func clientSecret() -> String { return clarifaiClientSecret }
}
