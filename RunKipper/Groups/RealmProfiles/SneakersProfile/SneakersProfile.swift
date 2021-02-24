//
//  SneakersProfile.swift
//  RunKipper
//
//  Created by Дмитрий on 2/10/21.
//  Copyright © 2021 DK. All rights reserved.
//

import UIKit
import RealmSwift

class SneakersProfile: Object {
    @objc dynamic var brand = ""
    @objc dynamic var model = ""
    @objc dynamic var name = ""
    @objc dynamic var mileage = 0
    @objc dynamic var term = 0
    override static func primaryKey() -> String? {
        return "name"
    }

}
