//
//  Utils.swift
//  Weather
//
//  Created by Damien Bannerot on 19/11/2017.
//  Copyright © 2017 Damien Bannerot. All rights reserved.
//

import Foundation
import CoreLocation

extension Date {
	func getCurrentForecastDateString() -> String {
		// set current date in user timezone
		var forecastDate = Date()
		var calendar = Calendar.current
		calendar.timeZone = .current
		// find hour corresponding to the API hour intervals
		while calendar.dateComponents([.hour], from: forecastDate).hour!%3 != 1 {
			forecastDate.addTimeInterval(-3600)
		}
		// get clean date without minutes and seconds
		let forecastDateComponents = calendar.dateComponents([.year, .month, .day, .hour], from: forecastDate)
		let cleanForecastDate = calendar.date(from: forecastDateComponents)!
		// formatting the date to string
		let formatter = DateFormatter()
		formatter.timeZone = TimeZone.current
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		return formatter.string(from: cleanForecastDate)
	}
	
	func getCurrentForecastDate() -> Date {
		// set current date in user timezone
		var forecastDate = Date()
		var calendar = Calendar.current
		calendar.timeZone = .current
		// find hour corresponding to the API hour intervals
		while calendar.dateComponents([.hour], from: forecastDate).hour!%3 != 1 {
			forecastDate.addTimeInterval(-3600)
		}
		// get clean date without minutes and seconds
		let forecastDateComponents = calendar.dateComponents([.year, .month, .day, .hour], from: forecastDate)
		let cleanForecastDate = calendar.date(from: forecastDateComponents)!
		return cleanForecastDate
	}
}

extension Double {
	// get the temperature in °C (CoreData entities temperature is in °K)
	func kelvinToCelsius() -> Double {
		return self-273.15
	}
}

extension String {
	// helper for localized strings
	var localized: String {
		return NSLocalizedString(self, comment: "")
	}
}


func location(fromAddress address: String, completion: @escaping (CLLocation?) -> Void) {
	let geoCoder = CLGeocoder()
	geoCoder.geocodeAddressString(address, in: nil, preferredLocale: Locale.current) { (placemarks, error) in
		if let placemarks = placemarks {
			if let place = placemarks.first, let location = place.location {
				completion(location)
			}
		}
		completion(nil)
	}
}
