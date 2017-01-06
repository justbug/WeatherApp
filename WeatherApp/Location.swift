//
//  Location.swift
//  WeatherApp
//
//  Created by Mark Chen on 2016/11/12.
//  Copyright © 2016年 Mark Chen. All rights reserved.
//

import CoreLocation

class Location {
    static var sharedInstance = Location()
    private init(){}
    var latitude: Double!
    var longitude: Double! 
}
