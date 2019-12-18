//
//  AppState.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 17/12/2019.
//  Copyright © 2019 Stefano Martina. All rights reserved.
//

import Foundation
import Katana
import GoogleMaps

struct AppState : State {
    var num : Int = 0
}


struct DummyStateUpdater: StateUpdater {
    func updateState(_ state: inout AppState) {
        state.num += 1
    }
}
