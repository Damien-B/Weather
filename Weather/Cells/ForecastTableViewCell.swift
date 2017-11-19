//
//  ForecastTableViewCell.swift
//  Weather
//
//  Created by Damien Bannerot on 19/11/2017.
//  Copyright © 2017 Damien Bannerot. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {

	@IBOutlet weak var forecastNameLabel: UILabel!
	@IBOutlet weak var forecastTemperatureLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
