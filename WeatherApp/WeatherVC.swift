//
//  ViewController.swift
//  WeatherApp
//
//  Created by Mark Chen on 2016/10/28.
//  Copyright © 2016年 Mark Chen. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class WeatherVC: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherLabel: UILabel!

    var Today_Weather: Weather!
    var forecasts = [Forecast]()
    let locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
        Today_Weather = Weather()

    }
    
    func downLoadForecastDetails(completed: @escaping DownloadComplete){
        let currentForecastURL = URL(string: forecast_url)!
        Alamofire.request(currentForecastURL, method: .get).responseJSON{response in
            let result = response.result
            
            if let dic = result.value as? Dictionary<String, AnyObject> {
                if let list = dic["list"] as? [Dictionary<String, AnyObject>] {
                    for item in list {
                        let forecast = Forecast(weather_dic: item)
                        self.forecasts.append(forecast)
                    }
                }
            
            }
            completed()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            if let locaiotn = locationManager.location {
                currentLocation = locaiotn
            }
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            
            Today_Weather.downLoadWeatherDetails{
                self.updateUI()
            }
            
            self.downLoadForecastDetails {
                self.forecasts.remove(at: 0)
                self.tableView.reloadData()
            }
            print(Location.sharedInstance.latitude, Location.sharedInstance.longitude)
            
        }else {
            locationManager.requestWhenInUseAuthorization()
        }

    }
    
    func updateUI() {
        dateLabel.text = Today_Weather.date
        cityNameLabel.text = Today_Weather.cityName
        currentTempLabel.text = String(Today_Weather.currentTemp) + "°"
        currentWeatherImage.image = UIImage(named: Today_Weather.weatherType)
        currentWeatherLabel.text = Today_Weather.weatherType
    }
    
    //# MARK: - tableviewDatasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ForecastWeatherCell{
            
            let forecast = forecasts[indexPath.row]
            
            cell.forecastDay.text = forecast.date
            cell.forecastHighTemp.text = String(forecast.highTemp)
            cell.forecastLowTemp.text = String(forecast.lowTemp)
            cell.forecastImage.image = UIImage(named: forecast.weatherType)
            cell.forecastType.text = forecast.weatherType
            
            return cell
        }else {
            return ForecastWeatherCell()
        }
    }
}

