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
import SwiftyJSON

struct AppState : State {
    var num : Int = 0
    var resp : JSON = ""
}


struct DummyStateUpdater: StateUpdater {
    func updateState(_ state: inout AppState) {
        print("CLICK")
    }
}


struct TestStateUpdater: StateUpdater {
  let newValue: JSON

  func updateState(_ state: inout AppState) {
    print(self.newValue)
    state.resp = self.newValue
  }
}

struct GetEvent: SideEffect {
    func sideEffect(_ context: SideEffectContext<AppState, DependenciesContainer>) throws{
        context.dependencies.ApiManager
            .getEvent()
            .then{
                //newValue in TestStateUpdater(newValue: newValue)
                newValue in context.dispatch(TestStateUpdater(newValue: newValue))
        }
    }
}



