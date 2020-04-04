//
//  AddMonitoredPlaceViewController.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 20/03/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import Tempura

// MARK: - ViewController
class AddMonitoredPlaceViewController: ViewController<AddMonitoredPlaceView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupInteraction() {
        rootView.didTapClose = { [unowned self] in
            self.dismiss(animated: true, completion: nil)
        }

        rootView.didTapApply = { [unowned self] name, coordinate, magnitude, radius in
            self.dispatch(AddMonitoredPlace(name: name, coordinate: coordinate, magnitude: magnitude, radius: radius))
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
