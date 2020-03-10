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

struct DetailedEventStateUpdater: StateUpdater {
    let newValue: JSON
    func updateState(_ state: inout AppState) {
        let time_in = Double(newValue["properties"]["time"].stringValue) ?? 0
        let id = newValue["id"].stringValue
        let name = newValue["properties"]["place"].stringValue
        let magnitudo = newValue["properties"]["mag"].stringValue
        let coordinates = "\(newValue["geometry"]["coordinates"][0].stringValue) \(newValue["geometry"]["coordinates"][1].stringValue)"
        let depth = newValue["properties"]["products"]["origin"][0]["properties"]["depth"].stringValue
        state.displayEvent = DetailedEvent(id: id, name: name, descr: "No description", magnitudo: magnitudo, coordinates: coordinates, time_in: time_in, depth: depth)
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

struct InitState: StateUpdater {
    var InState: AppState
    func updateState(_ state: inout AppState) {
        state.events = InState.events
        state.filteringValue = InState.filteringValue
        state.message = InState.message
        state.displayEvent = InState.displayEvent
        state.segmentedDays = InState.segmentedDays
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

struct GetDetailedEvent: SideEffect {
    let id: String
    func sideEffect(_ context: SideEffectContext<AppState, DependenciesContainer>) throws {
        context.dependencies.ApiManager
            .getDetailedEvent(id: id)
            .then {
                newValue in context.dispatch(DetailedEventStateUpdater(newValue: newValue))
            }
    }
}

struct InitAppState: SideEffect {
    func sideEffect(_ context: SideEffectContext<AppState, DependenciesContainer>) throws {
        let file = "file.json"
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
            let fileURL = dir.appendingPathComponent(file)
            let decoder: JSONDecoder = JSONDecoder.init()
            
            //reading
            do {
                let data = try Data.init(contentsOf: URL(resolvingAliasFileAt: fileURL))
                let state: AppState = try decoder.decode(AppState.self, from: data)
                context.dispatch(InitState(InState: state))
            }
            catch {
                print("ERRORE LETTURA")
            }
        }
    }
}
