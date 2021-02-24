//
//  WeatherMainModel.swift
//  RunKipper
//
//  Created by Дмитрий on 12/28/20.
//  Copyright © 2020 DK. All rights reserved.
//

import UIKit

class WeatherMainModel: Codable {
var temp = 0.0
   
   enum CodingKeys: String, CodingKey {
       case temp
   }
   required convenience init(from decoder: Decoder) throws {
       self.init()
       let values = try decoder.container(keyedBy: CodingKeys.self)
       temp = try values.decode(Double.self, forKey: .temp) ?? 0
   }
}
