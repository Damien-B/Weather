//
//  Tests.swift
//  Weather
//
//  Created by Damien Bannerot on 19/11/2017.
//  Copyright © 2017 Damien Bannerot. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

class Tests {
	
	func createParisForecast() {
		let loc = CLLocation(latitude: 48.8866182, longitude: 2.3357255)
		APIManager.shared.retrieveForecast(forPosition: loc) { (error, forecast) in
			if let forecast = forecast {
//				let entity = NSEntityDescription.entity(forEntityName: "Forecast", in: CoreDataManager.shared.managedObjectContext)!
//				let test = Forecast.init(withAPIForecast: forecast, position: loc, date: Date().getCurrentForecastDate(), isUserLocation: false, entity: entity, insertInto: CoreDataManager.shared.managedObjectContext)
//				try! CoreDataManager.shared.managedObjectContext.save()
				CoreDataManager.shared.saveForecast(withForecast: forecast, location: loc, cityName: "PARIS PARIS PARIS PARIS PARIS PARIS PARIS PARIS PARIS PARIS PARIS PARIS PARIS PARIS PARIS PARIS PARIS PARIS PARIS PARIS ")
			}
		}
	}
	
	
	
	
}
