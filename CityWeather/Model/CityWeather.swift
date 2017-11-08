//
//  CityWeather.swift
//  CityWeather
//
//  Created by Edmund Trujillo on 11/7/17.
//  Copyright © 2017 Edmund Trujillo. All rights reserved.
//

import Foundation

struct CityWeather {
    var city : String?          // if this is nil then we don't have a valid city
    var weather : String?
    var windSpeed : String?     // all of these are strings as we do no calculations .. just display raw numbers
    var temperature : String?
    var pressure : String?
    var humidity : String?
    var latitude : Double?
    var longitude : Double?
    var icon : String?
    var iconUrl : URL?          // package up the iconURL in the model for the UI
}

