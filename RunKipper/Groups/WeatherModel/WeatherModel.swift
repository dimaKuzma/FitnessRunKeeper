//
//  WeatherModel.swift
//  RunKipper
//
//  Created by Дмитрий on 12/28/20.
//  Copyright © 2020 DK. All rights reserved.
//

import UIKit

class WeatherModel: Codable {
    var name = ""
    var main: WeatherMainModel?
    var weather = [WeatherWeatherModel]()
    var sys: WeatherSysModel?
    
    enum CodingKeys: String, CodingKey {
        case name, main, weather, sys
    }
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name) ?? ""
        main = try values.decode(WeatherMainModel.self, forKey: .main)
        weather = try values.decode([WeatherWeatherModel].self, forKey: .weather)
        sys = try values.decode(WeatherSysModel.self, forKey: .sys)
        
    }

}
