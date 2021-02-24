//
//  Location.swift
//  RunKipper
//
//  Created by Дмитрий on 2/11/21.
//  Copyright © 2021 DK. All rights reserved.
//

import UIKit
import RealmSwift

class Location: Object {
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    
    required convenience init(_ latitude: Double, _ longitude: Double) {
        self.init()
        self.latitude = latitude
        self.longitude = longitude
    }
}
