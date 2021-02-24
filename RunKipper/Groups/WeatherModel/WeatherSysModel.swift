//
//  WeatherSysModel.swift
//  RunKipper
//
//  Created by Дмитрий on 2/15/21.
//  Copyright © 2021 DK. All rights reserved.
//

import UIKit

class WeatherSysModel: Codable {
   var sunrise = 0
   var sunset = 0
   
   enum CodingKeys: String, CodingKey {
       case sunrise, sunset
   }
   required convenience init(from decoder: Decoder) throws {
       self.init()
       let values = try decoder.container(keyedBy: CodingKeys.self)
       sunrise = try values.decode(Int.self, forKey: .sunrise)
       sunset = try values.decode(Int.self, forKey: .sunset)
   }
}
