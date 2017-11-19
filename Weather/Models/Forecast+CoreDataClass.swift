//
//  Forecast+CoreDataClass.swift
//  Weather
//
//  Created by Damien Bannerot on 19/11/2017.
//  Copyright © 2017 Damien Bannerot. All rights reserved.
//
//

import Foundation
import CoreData
import CoreLocation

@objc(Forecast)
public class Forecast: NSManagedObject {
	
	convenience init(withAPIForecast forecast: APIForecast, cityName: String = "Lieu inconnu", position: CLLocation, date: Date, isUserLocation: Bool = false, entity: NSEntityDescription, insertInto managedObjectContext: NSManagedObjectContext) {
		self.init(entity: entity, insertInto: managedObjectContext)
		self.cityName = cityName
		temperature = forecast.temperature
		latitude = position.coordinate.latitude
		longitude = position.coordinate.longitude
		wind = forecast.wind
		windDirection = Int16(forecast.windDirection)
		nebulosity = Int16(forecast.nebulosity)
		rain = forecast.rain
		self.date = date as NSDate
		self.isUserLocation = isUserLocation
	}
	
	func update(withAPIForecast forecast: APIForecast, date: Date) {
		temperature = forecast.temperature
		wind = forecast.wind
		windDirection = Int16(forecast.windDirection)
		nebulosity = Int16(forecast.nebulosity)
		rain = forecast.rain
		self.date = date as! NSDate
	}
	
	func isUpToDate() -> Bool {
		guard let forecastDate = self.date, let currentDate = Date().getCurrentForecastDate() as? NSDate else {
			return false
		}
		return forecastDate == currentDate
	}
	
}
