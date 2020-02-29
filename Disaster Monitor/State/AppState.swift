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

struct AppState : State, Codable{
    var name : String = ""
    var surname : String = ""
    var events: [Event] = []        // Actual list containing Events correctly formatted, others for displaying pourposes
    var user: Profile = Profile(name: "", surname: "")
    var filteringValue : Float = 0
    var message : String = "Message to be shared\nSent from Disaster Monitor App"
    var displayEvent : DetailedEvent = DetailedEvent(id: "", name: "", descr: "", magnitudo: "", coordinates: ". .", time_in: 0)
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
  }
}

struct SetThreshold: StateUpdater{
    var value: Float
    func updateState(_ state: inout AppState) {
        state.filteringValue = value
    }
}

struct GetEvents: SideEffect {
    func sideEffect(_ context: SideEffectContext<AppState, DependenciesContainer>) throws{
        context.dependencies.ApiManager
            .getEvents()
            .then{
                newValue in context.dispatch(EventsStateUpdater(newValue: newValue))
        }
    }
}



