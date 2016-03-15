//
//  ReactiveViewI.swift
//  Weather
//
//  Created by Borja on 18/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import Foundation

protocol ReactiveView {
    func bindViewModel(withViewModel viewModel: AnyObject)
}