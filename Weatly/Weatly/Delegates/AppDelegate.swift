//
//  AppDelegate.swift
//  Weatly
//
//  Created by Roman Mishchenko on 23.03.2020.
//  Copyright © 2020 Roman Mishchenko. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var modelArray: [Model] = []
    var context = PersistentService.context
    
//    Get Weather components from Core Data
    func fetchWeatherFromStorage(completion: @escaping ([WeatherClass]) -> ()) {
            do {
                let saved = try self.context.fetch(WeatherClass.fetchRequest())
                completion(saved as! [WeatherClass])
            } catch let error as NSError {
                print("---------------")
                print("Could not fetch \(error), \(error.userInfo)")
            }
    }

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
       
//        Filter if it's old data
        fetchWeatherFromStorage { (saved) in
            let timeInterval = NSDate().timeIntervalSince1970
            for item in saved {
                if item.dt > timeInterval {
                    self.modelArray.append(Model(descript: item.descript!, dt: item.dt, dtTxt: item.dt_txt ?? "lol", windSpeed: item.windSpeed, cloudiness: item.cloudiness, temperature: item.temperature, pressure: item.pressure, humidity: item.humidity))
                }
            }
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    

}

