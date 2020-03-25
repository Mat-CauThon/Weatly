//
//  WeatherClass+CoreDataProperties.swift
//  Weatly
//
//  Created by Roman Mishchenko on 25.03.2020.
//  Copyright © 2020 Roman Mishchenko. All rights reserved.
//
//

import Foundation
import CoreData


extension WeatherClass {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherClass> {
        return NSFetchRequest<WeatherClass>(entityName: "WeatherClass")
    }

    @NSManaged public var cloudiness: Int16
    @NSManaged public var descript: String?
    @NSManaged public var dt: Double
    @NSManaged public var humidity: Int16
    @NSManaged public var pressure: Int16
    @NSManaged public var temperature: Int32
    @NSManaged public var windSpeed: Float
    @NSManaged public var dt_txt: String?

}
