//
//  AppState.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 17/12/2019.
//  Copyright © 2019 Stefano Martina. All rights reserved.
//

import Foundation
import Katana
import Hydra
import GoogleMaps

struct AppState : State {
    var num : Int = 0
    var resp : String = ""
}


struct DummyStateUpdater: StateUpdater {
    func updateState(_ state: inout AppState) {
        state.num += 1
    }
}


struct TestStateUpdater: StateUpdater {
  let newValue: String
  
  func updateState(_ state: inout AppState) {
    state.resp = self.newValue
  }
}

struct GetEvent: SideEffect {
    func sideEffect(_ context: SideEffectContext<AppState, DependenciesContainer>) throws{
        context.dependencies.ApiManager
            .getEvent()
            .thenDispatch({ newValue in TestStateUpdater(newValue: newValue) })
    }
}



