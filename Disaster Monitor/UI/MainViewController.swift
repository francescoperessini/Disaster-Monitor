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
        self.dispatch(GetEvent())
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dispatch(GetEvent())
        self.store.dispatch(DummyStateUpdater())
    }
    
    override func setupInteraction() {
        rootView.didTapFilter = { [unowned self] in
            self.dispatch(GetEvent())
        }
    }
    
}

enum Screen: String {
    case home
}
