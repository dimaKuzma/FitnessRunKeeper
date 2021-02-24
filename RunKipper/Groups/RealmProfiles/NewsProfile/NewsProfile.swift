//
//  NewsProfile.swift
//  RunKipper
//
//  Created by Дмитрий on 2/5/21.
//  Copyright © 2021 DK. All rights reserved.
//

import UIKit
import RealmSwift

class NewsProfile: Object {
    @objc dynamic var distance = 0.0
    @objc dynamic var time = ""
    @objc dynamic var timeInSeconds = 0
    @objc dynamic var fullDate = ""
    @objc dynamic var shortDate = ""
    @objc dynamic var temp = ""
    @objc dynamic var tempInSeconds = 0
    @objc dynamic var pulse = 0
    @objc dynamic var note = ""
    @objc dynamic var calory = 0
    dynamic var route = List<Location>()
    override static func primaryKey() -> String? {
        return "fullDate"
    }

}
