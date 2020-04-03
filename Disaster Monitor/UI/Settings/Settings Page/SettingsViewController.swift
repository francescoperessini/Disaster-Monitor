//
//  SettingsViewController.swift
//  Disaster Monitor
//
//  Created by Francesco Peressini on 19/12/2019.
//  Copyright © 2019 Stefano Martina. All rights reserved.
//

import Tempura

// MARK: - ViewController
class SettingsViewController: ViewController<SettingsView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    override func setupInteraction() {
        rootView.didTapEditMessage = {
            let vc = UINavigationController(rootViewController: MessageEditorViewController(store: self.store))
            self.present(vc, animated: true, completion: nil)
        }
        
        rootView.didTapEditMonitoredLocations = { [unowned self] in
            let vc = MonitoredRegionViewController(store: self.store)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        rootView.didTapStylingColor = { [unowned self] color in
            self.dispatch(UpdateCustomColor(color: color))
        }
        
        rootView.didTapNotificationSwitch = { [unowned self] value in
            self.dispatch(SetNotificationMode(value: value))
        }
        
        rootView.didTapDebugSwitch = { [unowned self] value in
            self.dispatch(SetDebugMode(value: value))
        }
        
    }
    
}
