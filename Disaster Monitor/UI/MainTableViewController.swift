//
//  MainTableViewController.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 28/02/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import Tempura

// MARK: - ViewController
class MainTableViewController: ViewController<MainViewTableView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dispatch(GetEvent())
    }
    
    override func setupInteraction() {
        rootView.didTapFilter = {
            let vc = UINavigationController(rootViewController: FilterViewController(store: self.store))
            self.present(vc, animated: true, completion: nil)
        }
        
        rootView.didTapEvent = { [unowned self] v in
            let vc = UINavigationController(rootViewController: EventViewController(store: self.store, id: v))
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}
