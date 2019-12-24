//
//  SettingsViewController.swift
//  Disaster Monitor
//
//  Created by Francesco Peressini on 19/12/2019.
//  Copyright © 2019 Stefano Martina. All rights reserved.
//

import UIKit
import Katana
import Tempura
import PinLayout


// MARK: - View Controller
// Ha la responsabilità di passare alla view un nuovo viewmodel a ogni update
class SettingsViewController: ViewController<SettingsView> {  // Extension of UIViewController
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Settings"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func setupInteraction() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

enum Settings: String {
    case home
}
