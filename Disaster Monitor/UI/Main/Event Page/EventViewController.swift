//
//  EventViewController.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 25/02/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import Tempura
import SafariServices

class EventViewController: ViewControllerWithLocalState<EventView>, SFSafariViewControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupInteraction() {
        rootView.didTapSafari = { [unowned self] url in
            guard let url = URL(string: url) else { return }
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true, completion: nil)
            safariVC.delegate = self
        }
        
        rootView.didTapShare = { [unowned self] sender in
            let firstActivityItem = "Look at this: \(self.viewModel!.event!.name) with magnitude \(String(describing: self.viewModel!.event!.magnitudo)) \(self.viewModel!.event!.magType)"
            let secondActivityItem = self.viewModel!.event!.url
            
            let activityViewController : UIActivityViewController = UIActivityViewController(
                activityItems: [firstActivityItem, secondActivityItem], applicationActivities: nil)
            
            activityViewController.popoverPresentationController?.sourceView = self.navigationController?.view
            
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
            
            // Anything you want to exclude
            activityViewController.excludedActivityTypes = [
                UIActivity.ActivityType.postToWeibo,
                UIActivity.ActivityType.print,
                UIActivity.ActivityType.assignToContact,
                UIActivity.ActivityType.saveToCameraRoll,
                UIActivity.ActivityType.addToReadingList,
                UIActivity.ActivityType.postToFlickr,
                UIActivity.ActivityType.postToVimeo,
                UIActivity.ActivityType.postToTencentWeibo
            ]
            
            //check ipad
            if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
                activityViewController.popoverPresentationController?.sourceView = self.view
            }
            
            self.present(activityViewController, animated: true, completion: nil)
            
            // This line remove the arrow of the popover to show in iPad
            activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

struct EventControllerLocalState: LocalState {
    var id: String?
}
