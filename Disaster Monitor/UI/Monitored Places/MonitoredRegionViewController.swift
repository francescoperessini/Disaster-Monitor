//
//  MonitoredRegionViewController.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 20/03/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import Tempura

// MARK: - ViewController
class MonitoredRegionViewController: ViewController<MonitoredRegionsView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupInteraction() {
        rootView.didTapClose = {
            self.dismiss(animated: true, completion: nil)
        }
        
        rootView.didRemoveElement = { [unowned self] index in
            self.dispatch(RemoveMonitoredPlace(index: index))
        }
        
        rootView.didTapAdd = { [unowned self] in
            //self.dispatch(AddMonitoredPlace())
            let vc = UINavigationController(rootViewController: AddMonitoredPlaceViewController(store: self.store))
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}
