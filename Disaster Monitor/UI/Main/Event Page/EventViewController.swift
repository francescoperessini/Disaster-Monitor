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
        
        rootView.didTapShare = { [unowned self] (sender, url) in
            let activityItem = "Look at this: \(self.viewModel!.event!.name) with magnitude \(String(describing: self.viewModel!.event!.magnitudo)) \(self.viewModel!.event!.magType)\n\(url)"
            
            let activityViewController : UIActivityViewController = UIActivityViewController(
                activityItems: [activityItem], applicationActivities: nil)
            
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
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}

struct EventControllerLocalState: LocalState {
    var id: String?
}
