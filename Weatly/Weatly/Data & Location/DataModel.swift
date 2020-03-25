//
//  DataModel.swift
//  Weatly
//
//  Created by Roman Mishchenko on 23.03.2020.
//  Copyright © 2020 Roman Mishchenko. All rights reserved.
//

import Foundation
import SwiftUI
import MapKit

struct Model: Identifiable {
    
    var id = UUID()
//    var title: String
    var descript: String
    var dt: Double
    var dtTxt: String
    var windSpeed: Float
    var cloudiness: Int16
    var temperature: Int32
    var pressure: Int16
    var humidity: Int16
    
}

class DataModel: ObservableObject {
    
    @Published var modelData: [Model]
    @ObservedObject private var locationManager = LocationManager()
    init(modelData: [Model]) {
        self.modelData = modelData
       
    }
    
   
  
    
    func getElements() {
        
//        Get coordinates
        let coordinate = self.locationManager.location != nil ? self.locationManager.location!.coordinate : CLLocationCoordinate2D()
        print(coordinate)
        
        let latitude = Int(coordinate.latitude)
        let longitude = Int(coordinate.longitude)
        
//        Create url and refresh View
        let url = "http://api.openweathermap.org/data/2.5/forecast?lat=" + String(latitude) + "&lon=" + String(longitude) + "&appid=da92fe449a79100d5dba44224adfb855"
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.modelArray = []
        self.modelData = []
        preLoad(txt: url)
        
        
    }
    
//        Closure for downloadable data
    func preLoad(txt: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        load(url: txt) { (newWeather) in
            DispatchQueue.main.async {
                if newWeather.descript != "Load Error" {
                    self.modelData.append(newWeather)
                    appDelegate.modelArray.append(newWeather)
                }
            }
        }
    }
    
//        Load function
    func load(url: String, completion:@escaping (Model)->()) {
        
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            let safeURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let newUrl = URL(string: safeURL)!
            
            let task = URLSession.shared.dataTask(with: newUrl) { data, response, err in
                  
                guard let data = data, err == nil else {
                    completion(Model(descript: "Load Error", dt: 0, dtTxt: "", windSpeed: 0.0, cloudiness: 0, temperature: 0, pressure: 0, humidity: 0))
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    guard let parsedDict = json as? [String: Any] else {return}
                    guard let weatherDict = parsedDict["list"] as? [Any] else {return}
                    
                    for weather in weatherDict {
                        
                        guard let weatherInfo = weather as? [String: Any] else { print("Cant get weather info"); return}
                        guard let clouds = weatherInfo["clouds"] as? [String: Any] else {return}
                        guard var cloud = clouds["all"] as? Double else {return}
//                        Cause gray Circle in WeatherRow have max diametr 65
                        cloud = cloud*0.65
                        guard let dt = weatherInfo["dt"] as? Double else {return}
                        guard let dtTxt = weatherInfo["dt_txt"] as? String else {return}
                        
                        let arrayDt = dtTxt.components(separatedBy: [":","-"," "])
                        let dt_txt = arrayDt[1] + "-" + arrayDt[2] + " " + arrayDt[3] + ":" + arrayDt[4]
                        
                        guard let main = weatherInfo["main"] as? [String: Any] else {return}
                        guard let humidity = main["humidity"] as? Int16 else {return}
                        guard let pressure = main["pressure"] as? Int16 else {return}
                        guard var temp = main["temp"] as? Double else {return}
//                        In temp Kelvins
                        temp = temp - 273.15
                        guard let weatherTitle = weatherInfo["weather"] as? [Any] else {return}
                        var descript = ""
                        for title in weatherTitle {
                            guard let titleInfo = title as? [String: Any] else { print("Cant get weatherTtile info"); return}
                            guard let description = titleInfo["description"] as? String else {return}
                            descript = description
                        }
                        
                        guard let wind = weatherInfo["wind"] as? [String: Any] else {return}
                        guard let speed = wind["speed"] as? Double else {return}
                        
                        
                        let newWeather: Model = Model(descript: descript, dt: dt, dtTxt: dt_txt, windSpeed: Float(speed), cloudiness: Int16(cloud), temperature: Int32(temp), pressure: pressure, humidity: humidity)
                        completion(newWeather)
                        
                    }
                    
                    
                } catch {
                    print("Failed convert--------- \n \(error)")
                }
                
            
            }
            task.resume()
        }
    }
}
