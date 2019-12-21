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
    var name : String = ""
    var surname : String = ""
    var eventsList : [[String]] = [["","","","","a a"]]
    var events: [Event] = []
    var user: Profile = Profile(name: "", surname: "")
    
    var greaterOneList: [Event]{
        return self.events.filter { $0.greaterOne }
    }
}


struct EventsStateUpdater: StateUpdater {
  let newValue: JSON

  func updateState(_ state: inout AppState) {
    let arrayNames =  newValue["features"].arrayValue.map {$0["properties"]["place"].stringValue}
    let magnitudo = newValue["features"].arrayValue.map {$0["properties"]["mag"].stringValue}
    let description = newValue["features"].arrayValue.map {$0["properties"]["type"].stringValue}
    let coord = newValue["features"].arrayValue.map {"\($0["geometry"]["coordinates"][0].stringValue) \($0["geometry"]["coordinates"][1].stringValue)"}
    
    let result = zip(arrayNames, magnitudo, description, coord).map {[$0, $1, $2, $3] }
    state.eventsList = result
    
    state.events = result.map{Event(name: $0[0], descr: $0[1], magnitudo: $0[2], coordinates: $0[3])}
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



