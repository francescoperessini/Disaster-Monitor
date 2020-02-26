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
class ProfileViewController: ViewController<ProfileView> {  // Extension of UIViewController
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "My Profile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sharingInteraction))
    }
    
    @objc func sharingInteraction() {
        let activityController = UIActivityViewController(activityItems: [self.state.message], applicationActivities: nil)
        activityController.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
        present(activityController, animated: true, completion: nil)
    }
    
}
