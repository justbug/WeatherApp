//
//  Forecast.swift
//  WeatherApp
//
//  Created by Mark Chen on 2016/11/9.
//  Copyright © 2016年 Mark Chen. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class Forecast {
    private var _date: String!
    private var _weatherType: String!
    private var _highTemp: Double!
    private var _lowTemp: Double!
    var date: String {
        
        if _date == nil {
            _date = ""
        }
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var highTemp: Double {
        if _highTemp == nil {
            _highTemp = 0.0
        }
        return _highTemp
    }

    
    var lowTemp: Double {
        if _lowTemp == nil {
            _lowTemp = 0.0
        }
        return _lowTemp
    }
    
    init(weather_dic: Dictionary<String,AnyObject>) {
        if let temp = weather_dic["temp"] as? Dictionary<String, AnyObject> {
            
            if let max = temp["max"] as? Double {
                self._highTemp = kelvinToCelsius(temp: max)
            }
            
            if let min = temp["min"] as? Double {
                self._lowTemp = kelvinToCelsius(temp: min)
            }
            
        }
        
        if let weather = weather_dic["weather"] as? [Dictionary<String,AnyObject>] {
            if let main = weather[0]["main"] as? String {
                self._weatherType = main
            }
        }
        
        if let date = weather_dic["dt"] as? Double {
            let unixConvertDate = Date(timeIntervalSince1970: date)
            self._date = unixConvertDate.dayOfTheWeek()
        }
    }
    
    private func kelvinToCelsius(temp: Double) -> Double{
        return round(temp - 273.15)
    }
}

extension Date{
    func dayOfTheWeek() -> String {
         let dateformatter = DateFormatter()
         dateformatter.dateFormat = "EEEE"
         return dateformatter.string(from: self)
    }
}
