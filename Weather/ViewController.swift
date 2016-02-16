//
//  ViewController.swift
//  Weather
//
//  Created by Borja on 12/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        WeatherService.fetchCurrentWeather(forCity: "Madrid")
            .observeOn(UIScheduler())
            .startWithSignal { signal, disposable in
                        
            signal.observe { event in
                print("Event \(event)")
            switch event {
                case .Next:
                    print("Next event received: \(event.value)")
                case .Failed:
                    //TODO: show eeror
                    print("event failed: \(event.error)")
                    disposable.dispose()
                case .Completed:
                    print("Completed, value: \(event.value)")
                    disposable.dispose()
                default:
                    break
                }
            }
                
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

