//
//  ForecastsListViewController.swift
//  Weather
//
//  Created by Damien Bannerot on 19/11/2017.
//  Copyright © 2017 Damien Bannerot. All rights reserved.
//

import UIKit

class ForecastsListViewController: UIViewController {

	@IBOutlet weak var forecastsTableView: UITableView!
	
	var forecastsList = [Forecast]()
	
	override func viewDidLoad() {
        super.viewDidLoad()

		forecastsTableView.dataSource = self
		forecastsTableView.delegate = self
		
		forecastsTableView.rowHeight = UITableViewAutomaticDimension
		forecastsTableView.estimatedRowHeight = 100
		
		forecastsList = CoreDataManager.shared.retrieveAllSavedForecasts()
		forecastsTableView.reloadData()
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ForecastsListViewController: ActionTableViewCellDelegate {
	
	func buttonClicked(atIndexPath indexPath: IndexPath) {
			
			var TF: UITextField?
			// Create the AlertController
			let actionSheetController: UIAlertController = UIAlertController(title: "Ajouter une ville", message: "", preferredStyle: .alert)
			
			// Create and add the Cancel action
			let cancelAction: UIAlertAction = UIAlertAction(title: "Annuler", style: .cancel) { action -> Void in
				actionSheetController.dismiss(animated: true, completion: nil)
			}
			let nextAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
//				self.newForecastText = TF!.text!
//				LocationManager.shared.location(fromAddress: self.newForecastText!, completion: { (location) in
//					if let location = location {
//						APIManager.shared.retrieveForecast(forPosition: location, completion: { (error, forecast) in
//							if let forecast = forecast {
//								CoreDataManager.shared.saveForecast(withForecast: forecast, location: location, cityName: self.newForecastText!)
//								self.forecasts = CoreDataManager.shared.retrieveAllSavedForecasts()
//								self.tableView.reloadData()
//							}
//						})
//					}
//				})
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
	
}
