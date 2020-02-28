//
//  ProfileViewController.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 17/12/2019.
//  Copyright © 2019 Stefano Martina. All rights reserved.
//

import Tempura

// MARK: - ViewController
class ProfileViewController: ViewController<ProfileView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupInteraction() {
        rootView.didTapActionButton = {
            let activityController = UIActivityViewController(activityItems: [self.state.message], applicationActivities: nil)
            activityController.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            self.present(activityController, animated: true, completion: nil)
        }
    }
    
}
