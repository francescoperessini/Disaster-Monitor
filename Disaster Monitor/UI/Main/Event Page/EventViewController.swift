//
//  EventViewController.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 25/02/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import Tempura

class EventViewController: ViewControllerWithLocalState<EventView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


struct EventControllerLocalState: LocalState {
    var id: String?
}

