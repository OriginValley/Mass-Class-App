//
//  User.swift
//  Mass Class App
//
//  Created by Victor Orourke on 4/15/18.
//  Copyright © 2018 Origin Valley. All rights reserved.
//

import Foundation
import UIKit

class User: NSObject {
    var username: String
    
    init(username: String) {
        self.username = username
    }
    
    convenience override init() {
        self.init(username:  "")
    }
}
