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
    var name : String = ""
    var surname : String = ""
    var eventsList : [[String]] = [["","", ""]]
    var coordList: [[Int]] = [[0,0,0]]
    
    //var eventsList : [[String]] = [["a", "b"]]
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

struct EventsStateUpdater: StateUpdater {
  let newValue: JSON

  func updateState(_ state: inout AppState) {
    let arrayNames =  newValue["features"].arrayValue.map {$0["properties"]["title"].stringValue}
    let magnitudo = newValue["features"].arrayValue.map {$0["properties"]["mag"].stringValue}
    let description = newValue["features"].arrayValue.map {$0["properties"]["type"].stringValue}
    
    let result = zip(arrayNames, magnitudo, description).map {[$0, $1, $2] }
    state.eventsList = result

  }
}

struct GetEvent: SideEffect {
    func sideEffect(_ context: SideEffectContext<AppState, DependenciesContainer>) throws{
        context.dependencies.ApiManager
            .getEvent()
            .then{
                newValue in context.dispatch(EventsStateUpdater(newValue: newValue))
                
        }
    }
}



