//
//  CoreDataManager.swift
//  Weather
//
//  Created by Damien Bannerot on 19/11/2017.
//  Copyright © 2017 Damien Bannerot. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

class CoreDataManager: NSObject {
	
	static let shared = CoreDataManager()
	
	var managedObjectContext: NSManagedObjectContext
	
	override init() {
		let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		let storageURL = documentURL.appendingPathComponent("Weather.db")
		let modelURL = Bundle.main.url(forResource: "Weather", withExtension: "momd")
		let model = NSManagedObjectModel(contentsOf: modelURL!)
		let store = NSPersistentStoreCoordinator(managedObjectModel: model!)
		let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
		do {
			try store.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storageURL, options: nil)
			context.persistentStoreCoordinator = store
		} catch {
			print("error creating core data store")
		}
		self.managedObjectContext = context
		
		super.init()
	}
	
	// MARK: - Helpers
	
	func retrieveAllSavedForecasts() -> [Forecast] {
		var forecastsArray: [Forecast] = []
		let forecastsRequest: NSFetchRequest<Forecast> = Forecast.fetchRequest()
		do {
			let forecasts = try self.managedObjectContext.fetch(forecastsRequest) as [Forecast]
			if forecasts.count > 0 {
				for forecast in forecasts {
					forecastsArray.append(forecast)
				}
			} else {
				print("no existing forecast")
			}
		} catch {
			print("error fetching forecasts")
		}
		return forecastsArray
	}
	
	func retrieveForecast(withName name: String, location: CLLocation) -> Forecast? {
		let forecastsRequest: NSFetchRequest<Forecast> = Forecast.fetchRequest()
		forecastsRequest.predicate = NSPredicate(format: "cityName == %@", name)
		do {
			let forecasts = try self.managedObjectContext.fetch(forecastsRequest) as [Forecast]
			if forecasts.count > 0 {
				for forecast in forecasts {
					if location.distance(from: CLLocation(latitude: forecast.latitude, longitude: forecast.longitude)) < 1000 {// same place
						return forecast
					}
				}
			} else {
				print("no existing forecast")
			}
		} catch {
			print("error fetching forecasts")
		}
		return nil
	}
	
	func saveForecast(withForecast APIForecast: APIForecast, location: CLLocation, cityName: String) {
		if let forecast = retrieveForecast(withName: cityName, location: location) {// forecast is existing : update CoreData forecast
			if !forecast.isUpToDate() {// forecast should be updated
				forecast.update(withAPIForecast: APIForecast, date: Date().getCurrentForecastDate())
			} else {
				print("forecast already up to date")
			}
		} else {// create new CoreData forecast
			do {
				let entity = NSEntityDescription.entity(forEntityName: "Forecast", in: CoreDataManager.shared.managedObjectContext)!
				let newForecast = Forecast.init(withAPIForecast: APIForecast, cityName: cityName, position: location, date: Date().getCurrentForecastDate(), isUserLocation: false, entity: entity, insertInto: CoreDataManager.shared.managedObjectContext)
				try managedObjectContext.save()
			} catch {
				print("error saving forecast")
			}
		}
	}
	
	func deleteForecast(_ forecast: Forecast) {
		managedObjectContext.delete(forecast)
		do {
			try managedObjectContext.save()
		} catch {
			print(error.localizedDescription)
		}
		
	}
	
	
	// MARK: - Core Data stack
	
	lazy var persistentContainer: NSPersistentContainer = {
		/*
		The persistent container for the application. This implementation
		creates and returns a container, having loaded the store for the
		application to it. This property is optional since there are legitimate
		error conditions that could cause the creation of the store to fail.
		*/
		let container = NSPersistentContainer(name: "Weather")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				// Replace this implementation with code to handle the error appropriately.
				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				
				/*
				Typical reasons for an error here include:
				* The parent directory does not exist, cannot be created, or disallows writing.
				* The persistent store is not accessible, due to permissions or data protection when the device is locked.
				* The device is out of space.
				* The store could not be migrated to the current model version.
				Check the error message to determine what the actual problem was.
				*/
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()
	
	// MARK: - Core Data Saving support
	
	func saveContext () {
		let context = persistentContainer.viewContext
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				// Replace this implementation with code to handle the error appropriately.
				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
	
}


