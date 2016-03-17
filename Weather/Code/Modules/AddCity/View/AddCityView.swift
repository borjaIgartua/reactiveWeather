//
//  AddCityView.swift
//  Weather
//
//  Created by Borja on 18/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import UIKit
import ReactiveCocoa

class AddCityView : UIView, ReactiveView {
    
    let cityNameLabel = UILabel()
    let descriptionLabel = UILabel()
    let temperatureLabel = UILabel()
    let pressureLabel = UILabel()
    let humidityLabel = UILabel()
    let windSpeedLabel = UILabel()
    
     init() {
        super.init(frame: CGRectZero)
        
        cityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        cityNameLabel.textAlignment = .Center
        self.addSubview(cityNameLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.textAlignment = .Center
        self.addSubview(descriptionLabel)
        
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(temperatureLabel)
        
        pressureLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(pressureLabel)
        
        humidityLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(humidityLabel)
        
        windSpeedLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(windSpeedLabel)
        
        let views = ["cityNameLabel" : cityNameLabel, "descriptionLabel" : descriptionLabel, "temperatureLabel" : temperatureLabel, "pressureLabel" : pressureLabel, "humidityLabel" : humidityLabel, "windSpeedLabel" : windSpeedLabel]
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[cityNameLabel]-15-|", views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[descriptionLabel]-15-|", views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-170-[cityNameLabel]-4-[descriptionLabel]-10-[temperatureLabel]-10-[pressureLabel]-10-[humidityLabel]-10-[windSpeedLabel]-(>=10)-|",
            options: .AlignAllLeft, metrics: nil, views: views))
    }

     required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    func bindViewModel(withViewModel viewModel: AnyObject) {
        
        if let cityViewModel = viewModel as? CityViewModel {
            if (cityViewModel.nameProperty.value.length > 0) {
            
                cityNameLabel.rac_text <~ cityViewModel.nameProperty.producer.map { $0 }
                temperatureLabel.rac_text <~ cityViewModel.temperatureProperty.producer.map { "Temperatura: \($0)\(WeatherUnits.temperatureSymbol)" }
                pressureLabel.rac_text <~ cityViewModel.pressureProperty.producer.map { "Presión atmosférica: \($0) hPa" }
                humidityLabel.rac_text <~ cityViewModel.humidityProperty.producer.map { "Humedad: \($0)%" }
                windSpeedLabel.rac_text <~ cityViewModel.windSpeedProperty.producer.map { "Viento: \($0) \(WeatherUnits.windSymbol)" }
                descriptionLabel.rac_text <~ cityViewModel.descriptionsProperty.producer
                    .filter({ (descriptions) -> Bool in
                        return (descriptions?.count == 1);
                    }).map({ (descriptions) -> String in
                        
                        if let descriptions = descriptions {
                            let description = descriptions[0]
                            return description.description
                        }
                        
                        return ""
                    })
            }
        }
    }
}