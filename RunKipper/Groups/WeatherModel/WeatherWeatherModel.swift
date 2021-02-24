//
//  WeatherWeatherModel.swift
//  RunKipper
//
//  Created by Дмитрий on 1/5/21.
//  Copyright © 2021 DK. All rights reserved.
//

import UIKit

class WeatherWeatherModel: Codable {
    var main = ""
    var description = ""
   
   enum CodingKeys: String, CodingKey {
       case main, description
   }
   required convenience init(from decoder: Decoder) throws {
       self.init()
       let values = try decoder.container(keyedBy: CodingKeys.self)
       main = try values.decode(String.self, forKey: .main)
       description = try values.decode(String.self, forKey: .description)
   }
}
