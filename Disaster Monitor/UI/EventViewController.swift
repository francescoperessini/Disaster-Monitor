//
//  EventViewController.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 25/02/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import UIKit
import Katana
import Tempura



class EventViewController: ViewControllerWithLocalState<EventView> {  // Extension of UIViewController
    
    init(store: PartialStore<AppState>, id: String?=nil){
        super.init(store: store, localState: EventControllerLocalState(), connected: false)
        self.localState.id = id
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
    }
    
    override func setupInteraction() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

struct EventControllerLocalState: LocalState{
    var id: String? = nil
}
