//
//  FilterViewController.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 25/02/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import Tempura

// MARK: - ViewController
class FilterViewController: ViewController<FilterView> {
    
    override func viewDidLoad() {
           super.viewDidLoad()
       }
    
    override func setupInteraction() {
        rootView.didTapSlider = { [unowned self] v in
            self.dispatch(SetThreshold(value: v))
        }
        
        rootView.didTapClose = { [unowned self] in
            self.dismiss(animated: true, completion: nil)
        }
        
        rootView.didTapSegmented = { [unowned self] v in
            self.dispatch(SetSegmented(value: v))
        }
    }
    
}
