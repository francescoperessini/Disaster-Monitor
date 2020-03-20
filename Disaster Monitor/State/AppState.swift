//
//  AppState.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 17/12/2019.
//  Copyright © 2019 Stefano Martina. All rights reserved.
//

import Katana
import Hydra
import SwiftyJSON

struct AppState: State, Codable {
    var events: [Event] = []
    var filteringValue: Float = -1.0
    var message: String = "Message to be shared\nSent from Disaster Monitor App"
    var displayEvent: Event?
    var segmentedDays: Int = 7
    var customColor: Color = Color(name: colors.red)
    var dataSources: [String: Bool] = ["INGV": true, "USGS": true]
    var regions: [Region] = []
    var debugMode: Bool = true
    var searchString: String = ""
}

enum colors: Int, Codable {
    case red
    case blue
    case green
}

struct Color: Codable {
    var name: colors
    func getColor() -> UIColor {
        switch self.name {
        case colors.green:      return UIColor.systemGreen
        case colors.red:        return UIColor.systemRed
        default:                return UIColor.systemBlue
        }
    }
    
    func getColorName() -> String {
        switch self.name {
        case colors.green:      return "GREEN"
        case colors.red:        return "RED"
        default:                return "BLUE"
        }
    }
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
        let updated = newValue["features"].arrayValue.map {$0["properties"]["updated"].doubleValue}
        let dataSource = "USGS"
        
        for i in 0...arrayNames.count - 1 {
            //Unseen Event
            if !state.events.contains(where: { $0.id == id[i] }) {
                state.events.append(Event(id: id[i], name: arrayNames[i], descr: description[i], magnitudo: magnitudo[i], coordinates: coord[i], depth: depth[i], time: time[i], dataSource: dataSource, updated: updated[i]))
            }
            //Seen event, with an update
            else if state.events.contains(where: { $0.id == id[i] && $0.updated == updated[i]}) {
                let toRemoveEvent = state.events.firstIndex{$0.id == id[i] && $0.updated == updated[i] }
                state.events.remove(at: toRemoveEvent!)
                state.events.append(Event(id: id[i], name: arrayNames[i], descr: description[i], magnitudo: magnitudo[i], coordinates: coord[i], depth: depth[i], time: time[i], dataSource: dataSource, updated: updated[i]))
            }
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
        let dataSource = "INGV"
        var result_time: [Double] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        for time in time_str{
            guard let appo = dateFormatter.date(from: time) else { return }
            result_time.append(appo.timeIntervalSince1970 * 1000.0)
        }

        for i in 0...arrayNames.count - 1 {
            if !state.events.contains(where: { $0.id == id[i] }) {
                state.events.append(Event(id: id[i], name: arrayNames[i], descr: description[i], magnitudo: magnitudo[i], coordinates: coord[i], depth: depth[i], time: result_time[i], dataSource: dataSource, updated: 0))
            }
        }
        state.events.sort(by: {$0.time > $1.time})
    }
}

struct DeleteEvents: StateUpdater{
    func updateState(_ state: inout AppState) {
        state.events.removeAll()
    }
}

struct SearchEvent: StateUpdater{
    var text: String
    func updateState(_ state: inout AppState) {
        state.searchString = text
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

struct SetINGVPreference: StateUpdater {
    var value: Bool
    func updateState(_ state: inout AppState) {
        state.dataSources["INGV"] = value
    }
}

struct SetUSGSPreference: StateUpdater {
    var value: Bool
    func updateState(_ state: inout AppState) {
        state.dataSources["USGS"] = value
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
        state.customColor = InState.customColor
    }
}

struct UpdateCustomColor: StateUpdater {
    var color: Color
    func updateState(_ state: inout AppState) {
        state.customColor = color
    }
}

struct SetDebugMode: StateUpdater {
    var value: Bool
    func updateState(_ state: inout AppState) {
        state.debugMode = value
    }
}

struct AddEventDebugMode: StateUpdater {
    var event: Event
    func updateState(_ state: inout AppState) {
        state.events.insert(event, at: 0)
    }
}

struct GetEvents: SideEffect {
    func sideEffect(_ context: SideEffectContext<AppState, DependenciesContainer>) throws {
        
        let weekAgo = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = formatter.string(from: weekAgo)
        let fullFormattedDateArr = formattedDate.split(separator: " ")
        let date = String(fullFormattedDateArr[0])
        let time = String(fullFormattedDateArr[1])
        
        //context.dispatch(DeleteEvents())

        context.dependencies.ApiManager
            .getEventsUSGS(date: date, time: time)
            .then {
                newValue in
                context.dispatch(EventsStateUpdater(newValue: newValue))
        }
        context.dependencies.ApiManager
            .getEventsINGV(date: date, time: time)
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
                print(error)
            }
        }
    }
}
