//
//  EventViewController.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 25/02/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import UIKit
import Tempura

class EventViewController: ViewControllerWithLocalState<EventView> {  // Extension of UIViewController
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
        rootView.didTapClose = { [unowned self] in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIManager.getEvent(id : self.localState.id ?? "")
            .then{
                newValue in
                    let time_in = Double(newValue["properties"]["time"].stringValue) ?? 0
                    let id = newValue["id"].stringValue
                    let name = newValue["properties"]["place"].stringValue
                    let magnitudo = newValue["properties"]["mag"].stringValue
                    let coordinates = "\(newValue["geometry"]["coordinates"][0].stringValue) \(newValue["geometry"]["coordinates"][1].stringValue)"
                    let depth = newValue["properties"]["products"]["origin"][0]["properties"]["depth"].stringValue
                    self.localState.event = DetailedEvent(id: id, name: name, descr: "No description", magnitudo: magnitudo, coordinates: coordinates, time_in: time_in, depth: depth)
        }
    }
}

struct EventControllerLocalState: LocalState {
    var id: String? = nil
    var event: DetailedEvent?
}
