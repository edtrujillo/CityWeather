//
//  ViewController.swift
//  CityWeather
//
//  Created by Edmund Trujillo on 11/7/17.
//  Copyright © 2017 Edmund Trujillo. All rights reserved.
//

import UIKit
import MapKit
import Kingfisher

class ViewController: UIViewController, UITextFieldDelegate {
    
    fileprivate struct Constants {
        static let StartingCity : String = "New York"
        static let lastCityTypedKey : String = "lastValidCityTyped"
    }
    
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    let mapPin = MKPointAnnotation()
    var cityWeather : CityWeather? = CityWeather()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityNameTextField.delegate = self
        
        // Use a starting default city ... a better decision would be to fetch
        // the current location from the device and start with the closest city
        self.cityNameTextField.text = Constants.StartingCity
        
        // if we left off the last time with a city, try re-fetching the weather from there
        if let lastCityTyped = UserDefaults.standard.object(forKey: Constants.lastCityTypedKey) {
            self.cityNameTextField.text = String(describing:lastCityTyped)
        }
        
        // Fetch the weather given a city, model name and closure that will update the UI
        fetchWeather(self.cityNameTextField.text, cityWeather, updateUI(_:) )
    }
    
    // Fetch the new city when the user presses the RETURN or SEARCH button on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.cityNameTextField.resignFirstResponder()
        if let newCityName = textField.text {
            fetchWeather(newCityName, cityWeather!, updateUI(_:))
        }
        return true
    }

    // Update the user interface which includes the labels, the map and the icon image
    func updateUI(_ cityWeather: CityWeather) {
        
        if cityWeather.city != nil {
            self.descriptionLabel.text = String(describing:cityWeather.weather!)
            self.temperatureLabel.text = "Current Temp: \(String(describing:cityWeather.temperature!)) °F"
            self.humidityLabel.text = "Humidity : \(String(describing:cityWeather.humidity!)) %"
            self.pressureLabel.text = "Pressure : \(String(describing:cityWeather.pressure!)) hPa"
            self.windSpeedLabel.text = "Wind speed: \(String(describing:cityWeather.windSpeed!)) mph"
            
            // Determine the center and region of map to display given we have a latitude/longitude
            if (cityWeather.longitude != nil && cityWeather.latitude != nil) {
                let center = CLLocationCoordinate2D(latitude: cityWeather.latitude!, longitude: cityWeather.longitude!)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0))
                
                //set region on the map
                self.mapView.setRegion(region, animated: true)
                
                // drop a pin on the map with the name of the city on the pin
                self.mapPin.coordinate = center
                self.mapPin.title = self.cityNameTextField.text!
                self.mapView.addAnnotation(self.mapPin)
            }
            
            // Let the Kingfisher image control update the image asynchronously
            let url = cityWeather.iconUrl!
            self.iconImageView.kf.setImage(with: url)
            
            // Save the last valid city typed for the next time we start up
            UserDefaults.standard.set(self.cityNameTextField.text!, forKey: Constants.lastCityTypedKey)
        } else {
            
            // the user entered a cityname that cannot be deciphered ... let them know
            if let badCityName = self.cityNameTextField.text {
                let alert = UIAlertController(title: "City not found", message: "'\(badCityName)' is not a valid city name.", preferredStyle: UIAlertControllerStyle.alert)
                
                let action = UIAlertAction(title: "OK", style: .default) { action in
                    self.cityNameTextField.becomeFirstResponder()
                }
                
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

