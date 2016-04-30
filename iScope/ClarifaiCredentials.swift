//
//  ClarifaiCredentials.swift
//  iScope
//
//  Created by Poseidon Ho on 4/30/16.
//  Copyright © 2016 oi7. All rights reserved.
//

import Foundation;

let clarifaiClientID = "ENb4swQevB1oDlyG-mnytoZEM6Uuv9WE-Oy5WhGC"
let clarifaiClientSecret = "YEQYfnq-bh2KZkRYnUfTsm5tUbk9BtSdduwCdFYr"

@objc class Credentials : NSObject {
    class func clientID() -> String { return clarifaiClientID }
    class func clientSecret() -> String { return clarifaiClientSecret }
}
