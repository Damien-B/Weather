//
//  ForecastsListViewController.swift
//  Weather
//
//  Created by Damien Bannerot on 19/11/2017.
//  Copyright © 2017 Damien Bannerot. All rights reserved.
//

import UIKit
import CoreLocation

class ForecastsListViewController: UIViewController {

	@IBOutlet weak var forecastsTableView: UITableView!
	
	var forecastsList = [Forecast]()
	var newForecastText: String = ""
	
	override func viewDidLoad() {
        super.viewDidLoad()

		forecastsTableView.dataSource = self
		forecastsTableView.delegate = self
		
		forecastsTableView.rowHeight = UITableViewAutomaticDimension
		forecastsTableView.estimatedRowHeight = 100
		
		updateTableView()
		updateForecastsIfNecessary()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: - Helpers
	
	func updateTableView() {
		forecastsList = CoreDataManager.shared.retrieveAllSavedForecasts()
		forecastsTableView.reloadData()
	}
	
	func updateForecastsIfNecessary() {
		for forecast in forecastsList {
			if !forecast.isUpToDate() {// check for new data only if the date outdated
				let location = CLLocation(latitude: forecast.latitude, longitude: forecast.longitude)
				APIManager.shared.retrieveForecast(forPosition: location) { (error, APIforecast) in
					if let APIforecast = APIforecast {
						CoreDataManager.shared.saveForecast(withForecast: APIforecast, location: location, cityName: forecast.cityName ?? "Lieu inconnu")
						self.updateTableView()
					}
				}
			}
		}
	}

}

// MARK: - ActionTableViewCellDelegate

extension ForecastsListViewController: ActionTableViewCellDelegate {
	
	func buttonClicked(atIndexPath indexPath: IndexPath) {
			
			var TF: UITextField?
			// create the alert controller
			let actionSheetController: UIAlertController = UIAlertController(title: "Ajouter une ville", message: "", preferredStyle: .alert)
			
			// create and add the cancel action
			let cancelAction: UIAlertAction = UIAlertAction(title: "Annuler", style: .cancel) { action -> Void in
				actionSheetController.dismiss(animated: true, completion: nil)
			}
			let nextAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
				self.newForecastText = TF!.text!
				location(fromAddress: self.newForecastText, completion: { (location) in
					if let location = location {
						APIManager.shared.retrieveForecast(forPosition: location, completion: { (error, forecast) in
							if let forecast = forecast {
								CoreDataManager.shared.saveForecast(withForecast: forecast, location: location, cityName: self.newForecastText)
								self.updateTableView()
							}
						})
					}
				})
			}
			actionSheetController.addAction(cancelAction)
			actionSheetController.addAction(nextAction)
			// add a textfield
			actionSheetController.addTextField(configurationHandler: { (textField) in
				TF = textField
			})
			
			//Present the AlertController
			self.present(actionSheetController, animated: true, completion: nil)
	}
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ForecastsListViewController: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return forecastsList.count+1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row != forecastsList.count {
			if let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as? ForecastTableViewCell {
				cell.forecastNameLabel.text = forecastsList[indexPath.row].cityName!
				cell.forecastTemperatureLabel.text = String(format: "%.1f°C", forecastsList[indexPath.row].temperature.kelvinToCelsius())
				return cell
			}
		} else {
			if let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as? ActionTableViewCell {
				cell.buttonTitle = "FORECAST_LIST_VIEW_ADD_LOCATION".localized
				cell.delegate = self
				return cell
			}
			
		}
		let defaultCell = UITableViewCell()
		defaultCell.textLabel?.text = "default cell - a problem occured"
		return defaultCell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let detailViewController = storyboard.instantiateViewController(withIdentifier: "ForecastDetailViewController") as! ForecastDetailViewController
		detailViewController.forecast = forecastsList[indexPath.row]
		if let navigationController = navigationController {
			navigationController.pushViewController(detailViewController, animated: true)
		}
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return indexPath.row != forecastsList.count
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		CoreDataManager.shared.deleteForecast(forecastsList[indexPath.row])
		forecastsList.remove(at: indexPath.row)
		tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
	}
	
}
