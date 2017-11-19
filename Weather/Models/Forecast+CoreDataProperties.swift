//
//  Forecast+CoreDataProperties.swift
//  Weather
//
//  Created by Damien Bannerot on 19/11/2017.
//  Copyright © 2017 Damien Bannerot. All rights reserved.
//
//

import Foundation
import CoreData


extension Forecast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Forecast> {
        return NSFetchRequest<Forecast>(entityName: "Forecast")
    }

    @NSManaged public var cityName: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var isUserLocation: Bool
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var nebulosity: Int16
    @NSManaged public var rain: Float
    @NSManaged public var temperature: Double
    @NSManaged public var wind: Float
    @NSManaged public var windDirection: Int16

}
