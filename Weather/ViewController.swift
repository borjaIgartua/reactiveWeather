//
//  ViewController.swift
//  Weather
//
//  Created by Borja on 12/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        WeatherService.fetchCurrentWeather(forCity: "Madrid")
            .startWithSignal { signal, disposable in
                        
            signal.observe { event in
                print("Event \(event)")
            switch event {
                case .Next:
                    print("Next event received: \(event.value)")
                case .Failed:
                    print("event failed: \(event.error)")
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

