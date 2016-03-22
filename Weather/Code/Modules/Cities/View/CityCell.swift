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
    
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let messageLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .None
        
        let contentView = self.contentView
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(messageLabel)
        
        let views = ["titleLabel" : titleLabel, "descriptionLabel" : descriptionLabel, "messageLabel" : messageLabel]
        
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

            }
        }
        
    }
}