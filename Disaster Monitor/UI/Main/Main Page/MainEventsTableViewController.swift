//
//  MainEventsTableViewController.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 28/02/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import Tempura

// MARK: - ViewController
class MainEventsTableViewController: ViewController<MainEventsView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dispatch(GetEvents())
    }
    
    override func setupInteraction() {
        rootView.didTapFilter = { [unowned self] in
            let vc = UINavigationController(rootViewController: FilterViewController(store: self.store))
            self.present(vc, animated: true, completion: nil)
        }
        
        rootView.didTapEvent = { [unowned self] id in
            let vc = EventViewController(store: self.store, localState: EventControllerLocalState(id: id))
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        rootView.didPullRefreshControl = {
            self.dispatch(GetEvents())
        }
        
        rootView.didTapSearch = { [unowned self] in
            self.present(self.rootView.searchController, animated: true, completion: nil)
        }
        
        rootView.end = { [unowned self] text in
            self.dispatch(SearchEvent(text: text))
        }
        
    }
    
}
