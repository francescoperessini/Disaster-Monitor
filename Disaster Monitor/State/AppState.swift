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
    var displayEvent: Event?
    var segmentedDays: Int = 999
}

struct EventsStateUpdater: StateUpdater {
    let newValue: JSON
    func updateState(_ state: inout AppState) {
        let arrayNames = newValue["features"].arrayValue.map {$0["properties"]["place"].stringValue}
        let description = newValue["features"].arrayValue.map {$0["properties"]["type"].stringValue}
        let magnitudo = newValue["features"].arrayValue.map {$0["properties"]["mag"].stringValue}
        let coord = newValue["features"].arrayValue.map {"\($0["geometry"]["coordinates"][0].stringValue) \($0["geometry"]["coordinates"][1].stringValue)"}
        let id = newValue["features"].arrayValue.map {$0["id"].stringValue}
        let time = newValue["features"].arrayValue.map {$0["properties"]["time"].doubleValue}
        let depth = newValue["features"].arrayValue.map{$0["geometry"]["coordinates"][2].floatValue}
        
        for i in 0...arrayNames.count - 1 {
            state.events.append(Event(id: id[i], name: arrayNames[i], descr: description[i], magnitudo: magnitudo[i], coordinates: coord[i], depth: depth[i], time: time[i]))
        }
        state.events.sort(by: {$0.time > $1.time})
    }
}

struct EventsStateUpdaterINGV: StateUpdater {
    let newValue: JSON
    func updateState(_ state: inout AppState) {
        let arrayNames = newValue["features"].arrayValue.map {$0["properties"]["place"].stringValue}
        let description = newValue["features"].arrayValue.map {$0["properties"]["type"].stringValue}
        let magnitudo = newValue["features"].arrayValue.map {$0["properties"]["mag"].stringValue}
        let coord = newValue["features"].arrayValue.map {"\($0["geometry"]["coordinates"][0].stringValue) \($0["geometry"]["coordinates"][1].stringValue)"}
        let id = newValue["features"].arrayValue.map {$0["properties"]["eventId"].stringValue}
        let time_str = newValue["features"].arrayValue.map {$0["properties"]["time"].stringValue}
        let depth = newValue["features"].arrayValue.map{$0["geometry"]["coordinates"][2].floatValue}
        var result_time: [Double] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS" //Your date format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC+0:00") //Current time zone
        
        for time in time_str{
            guard let appo = dateFormatter.date(from:time) else { return }
            result_time.append(appo.timeIntervalSince1970*1000.0)
        }

        for i in 0...arrayNames.count - 1 {
            state.events.append(Event(id: id[i], name: arrayNames[i], descr: description[i], magnitudo: magnitudo[i], coordinates: coord[i], depth: depth[i], time: result_time[i]))
        }
        state.events.sort(by: {$0.time > $1.time})
    }
}

struct DeleteEvents: StateUpdater{
    func updateState(_ state: inout AppState) {
        state.events.removeAll()
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
        context.dispatch(DeleteEvents())
        context.dependencies.ApiManager
            .getEventsUSGS()
            .then {
                newValue in
                    context.dispatch(EventsStateUpdater(newValue: newValue))
            }
        context.dependencies.ApiManager
        .getEventsINGV()
        .then {
            newValue in
                context.dispatch(EventsStateUpdaterINGV(newValue: newValue))
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
