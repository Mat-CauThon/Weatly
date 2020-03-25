//
//  SceneDelegate.swift
//  Weatly
//
//  Created by Roman Mishchenko on 23.03.2020.
//  Copyright © 2020 Roman Mishchenko. All rights reserved.
//

import UIKit
import SwiftUI
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Get the managed object context from the shared persistent container.
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Create the SwiftUI view and set the context as the value for the managedObjectContext environment keyPath.
        // Add `@Environment(\.managedObjectContext)` in the views that will need the context.
        let context = PersistentService.context
        let contentView = ContentView().environment(\.managedObjectContext, context)

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
//        Remove all from Core Data
        let moc = PersistentService.context
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WeatherClass")
        let result = try? moc.fetch(fetchRequest)
        let resultData = result as! [WeatherClass]
        for object in resultData {
            
            moc.delete(object)
        }
        do {
            try moc.save()
            print("saved!")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        } catch {}
        
        
        
//       New Article in Core Data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        for item in appDelegate.modelArray {
            do {
                let newWeather = NSEntityDescription.insertNewObject(forEntityName: "WeatherClass", into: moc)
                newWeather.setValue(item.cloudiness, forKey: "cloudiness")
                newWeather.setValue(item.descript, forKey: "descript")
                newWeather.setValue(item.dt, forKey: "dt")
                newWeather.setValue(item.dtTxt, forKey: "dt_txt")
                newWeather.setValue(item.humidity, forKey: "humidity")
                newWeather.setValue(item.pressure, forKey: "pressure")
                newWeather.setValue(item.temperature, forKey: "temperature")
                newWeather.setValue(item.windSpeed, forKey: "windSpeed")
                try PersistentService.context.save()
            } catch {
                print("Saving error \(error)")
            }
        }
        
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
//        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

