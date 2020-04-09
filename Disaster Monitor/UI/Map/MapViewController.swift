//
//  MapViewController.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 17/12/2019.
//  Copyright © 2019 Stefano Martina. All rights reserved.
//

import Tempura

// MARK: - ViewController
class MapViewController: ViewController<MapView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupInteraction() {
        rootView.didTapActionButton = { [unowned self] sender in
            let activityViewController = UIActivityViewController(activityItems: [self.state.message], applicationActivities: nil)
            
            // Anything you want to exclude
            activityViewController.excludedActivityTypes = [
                UIActivity.ActivityType.addToReadingList,
                UIActivity.ActivityType.assignToContact,
                UIActivity.ActivityType.mail,
                UIActivity.ActivityType.markupAsPDF,
                UIActivity.ActivityType.openInIBooks,
                UIActivity.ActivityType.postToFlickr,
                UIActivity.ActivityType.postToVimeo,
                UIActivity.ActivityType.print,
                UIActivity.ActivityType.saveToCameraRoll
            ]
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                activityViewController.modalPresentationStyle = .popover
                activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
                activityViewController.popoverPresentationController?.barButtonItem = sender
                self.present(activityViewController, animated: true, completion: nil)
            }
            else {
                self.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
    
}
