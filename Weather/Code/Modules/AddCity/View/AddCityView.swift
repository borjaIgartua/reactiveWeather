//
//  AddCityView.swift
//  Weather
//
//  Created by Borja on 18/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class AddCityView : UIView, ReactiveView {
    
    let backgroundImageView = UIImageView()
    let cityNameLabel = UILabel()
    let descriptionLabel = UILabel()
    let temperatureLabel = UILabel()
    let pressureLabel = UILabel()
    let humidityLabel = UILabel()
    let windSpeedLabel = UILabel()
    
     init() {
        super.init(frame: CGRect.zero)
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(backgroundImageView)
        
        cityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        cityNameLabel.textAlignment = .center
        self.addSubview(cityNameLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.textAlignment = .center
        self.addSubview(descriptionLabel)
        
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(temperatureLabel)
        
        pressureLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(pressureLabel)
        
        humidityLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(humidityLabel)
        
        windSpeedLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(windSpeedLabel)
        
        let views : [String: AnyObject] = ["backgroundImageView" : backgroundImageView, "cityNameLabel" : cityNameLabel, "descriptionLabel" : descriptionLabel, "temperatureLabel" : temperatureLabel, "pressureLabel" : pressureLabel, "humidityLabel" : humidityLabel, "windSpeedLabel" : windSpeedLabel]
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[backgroundImageView]|", views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[backgroundImageView]|", views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[cityNameLabel]-15-|", views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[descriptionLabel]-15-|", views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-170-[cityNameLabel]-4-[descriptionLabel]-10-[temperatureLabel]-10-[pressureLabel]-10-[humidityLabel]-10-[windSpeedLabel]-(>=10)-|",
            options: .alignAllLeft, metrics: nil, views: views))
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
                
                for description in cityViewModel.descriptionsProperty.value! { //always is one description
                    
                    let weatherDesc = description as WeatherDescription
                    if let weatheridentifier = Double(weatherDesc.id) {
                        
                        var imageName = ""
                        
                        if  weatheridentifier == 802 {
                            imageName = "city802.png"
                            
                        } else if  weatheridentifier == 804 ||  weatheridentifier > 900 {
                            imageName = "city501.png"
                            
                        } else if  weatheridentifier == 800 {
                            imageName = "city800.png"
                            
                        } else if  weatheridentifier == 501 {
                            imageName = "city501.png"
                            
                        }  else if  weatheridentifier < 600 && weatheridentifier >= 700 {
                            imageName = "city721.png"
                            
                        } else if weatheridentifier < 400 {
                            imageName = "city400.png"
                            
                        } else if weatheridentifier < 900 && weatheridentifier >= 800 {
                            imageName = "city802.png"
                            
                        } else if weatheridentifier < 600 && weatheridentifier >= 700 {
                            imageName = "city802.png"
                        }
                        
                        backgroundImageView.image = UIImage(named: imageName)
                    }
                }
            }
        }
    }
}
