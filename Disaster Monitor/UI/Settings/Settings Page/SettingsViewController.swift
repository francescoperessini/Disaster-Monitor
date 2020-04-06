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
        
        rootView.didTapMonitoredPlaces = { [unowned self] in
            let vc = MonitoredRegionViewController(store: self.store)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        rootView.didTapNotificationSwitch = { [unowned self] value in
            self.dispatch(SetNotificationMode(value: value))
        }
        
        rootView.didTapStylingColor = { [unowned self] color in
            self.dispatch(UpdateCustomColor(color: color))
        }
        
        rootView.didTapDebugSwitch = { [unowned self] value in
            self.dispatch(SetDebugMode(value: value)).then {
                if value {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Debug mode activated", message: "Fictitious event added!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                        let viewController = UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.rootViewController
                        viewController?.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
}
