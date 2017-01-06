//
//  File.swift
//  WeatherApp
//
//  Created by Mark Chen on 2016/11/7.
//  Copyright © 2016年 Mark Chen. All rights reserved.
//

import Foundation

private let url = "http://api.openweathermap.org/data/2.5/weather?"
private let lat = "lat="
private let lon = "&lon="
private let app_id = "&appid="
private let api_key = "e2ee57e2a28ac03ecd9188cc952c8e73"

typealias DownloadComplete = () -> ()

let weather_url = "\(url)\(lat)\(Location.sharedInstance.latitude!)\(lon)\(Location.sharedInstance.longitude!)\(app_id)\(api_key)"

let forecast_url = "http://api.openweathermap.org/data/2.5/forecast/daily?\(lat)\(Location.sharedInstance.latitude!)\(lon)\(Location.sharedInstance.longitude!)&cnt=10&mode=json&\(app_id)\(api_key)"
