//
//  AppState.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 17/12/2019.
//  Copyright © 2019 Stefano Martina. All rights reserved.
//

import Katana
import Hydra
import GoogleMaps
import SwiftyJSON

struct AppState: State, Codable {
    var events: [Event] = []
    var filteringValue: Float?
    var message: String = "Message to be shared\nSent from Disaster Monitor App"
    var displayEvent: DetailedEvent?
    var segmentedDays: Int = 999
}

struct EventsStateUpdater: StateUpdater {
    let newValue: JSON
    func updateState(_ state: inout AppState) {
        state.events.removeAll()
        let arrayNames = newValue["features"].arrayValue.map {$0["properties"]["place"].stringValue}
        let description = newValue["features"].arrayValue.map {$0["properties"]["type"].stringValue}
        let magnitudo = newValue["features"].arrayValue.map {$0["properties"]["mag"].stringValue}
        let coord = newValue["features"].arrayValue.map {"\($0["geometry"]["coordinates"][0].stringValue) \($0["geometry"]["coordinates"][1].stringValue)"}
        let id = newValue["features"].arrayValue.map {$0["id"].stringValue}
        let time = newValue["features"].arrayValue.map {$0["properties"]["time"].doubleValue}

        for i in 0...arrayNames.count - 1 {
            state.events.append(Event(id: id[i], name: arrayNames[i], descr: description[i], magnitudo: magnitudo[i], coordinates: coord[i], time: time[i]))
        }
    }
}

struct SetThreshold: StateUpdater {
    var value: Float
    func updateState(_ state: inout AppState) {
        state.filteringValue = value
    }
}

struct SetSegmented: StateUpdater {
    var value: Int
    func updateState(_ state: inout AppState) {
        state.segmentedDays = value
    }
}

struct SetMessage: StateUpdater {
    var newMessage: String
    func updateState(_ state: inout AppState) {
        state.message = newMessage
    }
}

struct GetEvents: SideEffect {
    func sideEffect(_ context: SideEffectContext<AppState, DependenciesContainer>) throws {
        context.dependencies.ApiManager
            .getEvents()
            .then {
                newValue in context.dispatch(EventsStateUpdater(newValue: newValue))
            }
    }
}
