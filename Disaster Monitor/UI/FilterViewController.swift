//
//  FilterViewController.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 25/02/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import UIKit
import Katana
import Tempura

class FilterViewController: ViewController<FilterView> {  // Extension of UIViewController
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func setupInteraction() {
        rootView.didTapSlider = { [unowned self] v in
            self.dispatch(SetThreshold(value: v))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    

}
