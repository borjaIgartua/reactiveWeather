//
//  CityCell.swift
//  Weather
//
//  Created by Borja on 16/3/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import UIKit
import ReactiveCocoa

class CityCell : UITableViewCell, ReactiveView  {
    
    let backgroundImageView = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let messageLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .None
        
        let contentView = self.contentView
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(backgroundImageView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(messageLabel)
        
        let views = ["backgroundImageView" : backgroundImageView, "titleLabel" : titleLabel, "descriptionLabel" : descriptionLabel, "messageLabel" : messageLabel]
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[backgroundImageView]|", views: views))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[backgroundImageView]|", views: views))
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[titleLabel]-15-|", views: views))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[descriptionLabel]-15-|", views: views))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[messageLabel]-15-|", views: views))
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-15-[titleLabel]-5-[descriptionLabel]-2-[messageLabel]-10-|", views: views))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func bindViewModel(withViewModel viewModel: AnyObject) {
        
        if let cityViewModel = viewModel as? CityViewModel {
            if (cityViewModel.nameProperty.value.length > 0) {
                
                titleLabel.rac_text <~ cityViewModel.nameProperty.producer.map { $0 }
                descriptionLabel.rac_text <~ cityViewModel.descriptionsProperty.producer
                    .filter({ (descriptions) -> Bool in
                        return (descriptions?.count == 1);
                    }).map({ (descriptions) -> String in
                        
                        if let descriptions = descriptions {
                            let description = descriptions[0]
                            return description.mainDescription
                        }
                        
                        return ""
                    })
                messageLabel.rac_text <~ cityViewModel.descriptionsProperty.producer
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
                    let weatheridentifier = Double(weatherDesc.id)
                    var imageName = ""
                    
                    if  weatheridentifier == 802 {
                        imageName = "weather802.png"
                        
                    } else if  weatheridentifier == 804 ||  weatheridentifier > 900 {
                        imageName = "weather804.png"
                        
                    } else if  weatheridentifier == 800 {
                        imageName = "weather800.png"
                        
                    } else if  weatheridentifier == 501 {
                        imageName = "weather501.png"
                        
                    }  else if  weatheridentifier < 600 && weatheridentifier >= 700 {
                        imageName = "weather721.png"
                        
                    } else if weatheridentifier < 400 {
                        imageName = "weather400.png"
                        
                    } else if weatheridentifier < 900 && weatheridentifier >= 800 {
                        imageName = "weather802.png"
                        
                    } else if weatheridentifier < 600 && weatheridentifier >= 700 {
                        imageName = "weather802.png"
                    }
                    
                    backgroundImageView.image = UIImage(named: imageName)
                }
            }
        }
        
    }
}