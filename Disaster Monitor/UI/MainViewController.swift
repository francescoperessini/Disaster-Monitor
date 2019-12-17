//
//  MainViewController.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 17/12/2019.
//  Copyright © 2019 Stefano Martina. All rights reserved.
//

import UIKit
import Katana
import Tempura
import PinLayout




// MARK: - View Controller
// Ha la responsabilità di passare alla view un nuovo viewmodel a ogni update
class MainViewController: ViewController<MainView> {  // Extension of UIViewController
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    override func setupInteraction() {
    }
}




enum Screen: String {
    case home
}
