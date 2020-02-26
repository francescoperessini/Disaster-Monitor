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
    var events: [Event] = []        // Actual list containing Events correctly formatted, others for displaying pourposes
    var user: Profile = Profile(name: "", surname: "")
    var filteringValue : Float = 0
    var message : String = "Message to be shared\nSent from Disaster Monitor App"
}


struct EventsStateUpdater: StateUpdater {
  let newValue: JSON

  func updateState(_ state: inout AppState) {
    let arrayNames =  newValue["features"].arrayValue.map {$0["properties"]["place"].stringValue}
    let description = newValue["features"].arrayValue.map {$0["properties"]["type"].stringValue}
    let magnitudo = newValue["features"].arrayValue.map {$0["properties"]["mag"].stringValue}
    let coord = newValue["features"].arrayValue.map {"\($0["geometry"]["coordinates"][0].stringValue) \($0["geometry"]["coordinates"][1].stringValue)"}
    let id = newValue["features"].arrayValue.map {$0["id"].stringValue}
    
    for i in 0...arrayNames.count-1{
        state.events.append(Event(id: id[i], name: arrayNames[i], descr: description[i], magnitudo: magnitudo[i], coordinates: coord[i]))
    }
    
    //let result = zip(arrayNames, description, magnitudo, coord).map {[$0, $1, $2, $3] }
    //state.events = result.map{Event(name: $0[0], descr: $0[1], magnitudo: $0[2], coordinates: $0[3])}
    
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


struct FilterEvent: StateUpdater {
    func updateState(_ state: inout AppState) {
        state.filteringValue = state.filteringValue + 0.5
        if state.filteringValue > 4 {
            state.filteringValue = 0
        }
    }
}


struct SetThreshold: StateUpdater{
    var value: Float
    func updateState(_ state: inout AppState) {
        state.filteringValue = value
    }
}



