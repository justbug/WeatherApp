//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Mark Chen on 2016/11/7.
//  Copyright © 2016年 Mark Chen. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


class Weather {
    private var _cityName: String!
    private var _date: String!
    private var _weatherType: String!
    private var _currentTemp: Double!

    var cityName: String {
        if _cityName == nil {
            _cityName = ""
        }
        return _cityName
    }
    
    var date: String {
        
        if _date == nil {
            _date = ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        let currentDate = dateFormatter.string(from: Date())
        _date = "Today, \(currentDate)"
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var currentTemp: Double {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        return _currentTemp
    }
    
    private func kelvinToCelsius(temp: Double) -> Double{
        return round(temp - 273.15)
    }
    
    func downLoadWeatherDetails(completed: @escaping DownloadComplete) {
        let currentWeatherURL = URL(string: weather_url)!
        //  .get is default
        Alamofire.request(currentWeatherURL, method: .get).responseJSON { response in
            let result = response.result
            
            if let dic = result.value as? Dictionary<String,AnyObject> {
                
                if let name = dic["name"] as? String {
                    self._cityName = name.capitalized
                }
            
                if let weather = dic["weather"] as? [Dictionary<String,AnyObject>] {
                    if let main = weather[0]["main"] as? String {
                        if main == "Drizzle"{
                            self._weatherType = "Rain Mini"
                        }else{
                            self._weatherType = main
                        }
                    }
                }
                
                if let main = dic["main"] as? Dictionary<String,AnyObject>{
                    if let temp = main["temp"] as? Double {
                        self._currentTemp = self.kelvinToCelsius(temp: temp)
                    }
                }
            }
            completed()
        }
    }
}
