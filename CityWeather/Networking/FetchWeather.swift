//
//  FetchWeather.swift
//  CityWeather
//
//  Created by Edmund Trujillo on 11/7/17.
//  Copyright © 2017 Edmund Trujillo. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

// This routine does the bulk of the heavy lifting ... it includes the URL's.
// It makes use of Alamofire for networking along with SwiftyJSON for easy and clean access to the JSON data

fileprivate struct Constants {
    static let weatherURL1: String = "https://api.openweathermap.org/data/2.5/weather?q="
    static let weatherURL2: String = "&units=imperial"
    static let weatherAPIKey: String = "&APPID=408e7c2703d05cda4138f8a2b6fb6c65"
    static let iconURL1: String = "https://openweathermap.org/img/w/"
    static let iconURL2: String = ".png"
}

func fetchWeather(_ cityName : String?, _ cityWeather: CityWeather?, _ completion:@escaping (_ cityWeather: CityWeather) -> Void) {
    var cityWeather = cityWeather!
    
    let sanitizedName = cityName?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    let path = Constants.weatherURL1 + sanitizedName! + Constants.weatherURL2 + Constants.weatherAPIKey

    Alamofire.request(path, headers:nil).responseJSON { response in
        
        if let alamoJson = response.result.value {
            let swiftJson = JSON(alamoJson)
            
            let cityName = swiftJson["name"].string
            cityWeather.city = cityName
            
            if cityName != nil {
                
                // fetch the first element of the weather array.  The UI doesn't use any more array entries
                // so we only use the first element... future update would be to accommodate multiple weather
                // entries and either append them to the weather string or create a new UI
                
                let weatherText = swiftJson["weather"][0]["description"]
                cityWeather.weather = String(describing: weatherText)
                
                let windSpeed = swiftJson["wind"]["speed"]
                cityWeather.windSpeed = String(describing: windSpeed)
                
                let humidity = swiftJson["main"]["humidity"]
                cityWeather.humidity = String(describing: humidity)
                
                let temperature = swiftJson["main"]["temp"]
                cityWeather.temperature = String(describing: temperature)
                
                let pressure = swiftJson["main"]["pressure"]
                cityWeather.pressure = String(describing: pressure)
                
                let latitude = swiftJson["coord"]["lat"].double
                let longitude = swiftJson["coord"]["lon"].double
                
                cityWeather.latitude = latitude
                cityWeather.longitude = longitude
                
                let icon = swiftJson["weather"][0]["icon"]
                let iconString = String(describing: icon)
                let iconPath = Constants.iconURL1 + iconString + Constants.iconURL2
                
                cityWeather.iconUrl = URL(string: iconPath)
            }
            
            completion(cityWeather)
        }
    }
}
