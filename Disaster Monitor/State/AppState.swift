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
    var events = [Event]()
    var magnitudeFilteringValue: Float = -1.0
    var displayedDays: Int = 7
    var dataSources: [String: Bool] = ["INGV": true, "USGS": true]
    var searchedString: String = ""
    var message: String = "Message to be shared\nSent from Disaster Monitor App"
    var isNotficiationEnabled: Bool = true
    var regions = [Region]()
    var customColor: Color = Color(name: .blue)
    var debugMode: Bool = false
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
        case colors.green:      return "Green"
        case colors.red:        return "Red"
        default:                return "Blue"
        }
    }
}

struct SearchEvent: StateUpdater {
    var text: String
    func updateState(_ state: inout AppState) {
        state.searchedString = text
    }
}

struct SetThreshold: StateUpdater {
    var value: Float
    func updateState(_ state: inout AppState) {
        state.magnitudeFilteringValue = value
    }
}

struct SetSegmented: StateUpdater {
    var value: Int
    func updateState(_ state: inout AppState) {
        state.displayedDays = value
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

struct UpdateCustomColor: StateUpdater {
    var color: Color
    func updateState(_ state: inout AppState) {
        state.customColor = color
    }
}

struct SetNotificationMode: StateUpdater {
    var value: Bool
    func updateState(_ state: inout AppState) {
        state.isNotficiationEnabled = value
    }
}

struct SetDebugMode: StateUpdater {
    var value: Bool
    func updateState(_ state: inout AppState) {
        state.debugMode = value
    }
}

struct AddDebugEvent: StateUpdater {
    var id: String
    var name: String
    func updateState(_ state: inout AppState) {
        // Creazione evento fittizio
        let tmp = Date()
        let time = tmp.timeIntervalSince1970 * 1000.0
        let event = Event(id: id, name: name, descr: "earthquake", magnitudo: "7.5", coordinates: "9.226937 45.478085", depth: 10.0, time: time, dataSource: "USGS", updated: time, magType: "ML", url: "https://www.polimi.it", felt: 0)
        state.events.append(event)
        state.events.sort(by: {$0.time > $1.time})
        var notifiedEvents = [Event]()
        if state.isNotficiationEnabled {
            notifiedEvents = LocalNotificationsManager.scheduleEventNotification(events: state.events, places: state.regions)
        }
        for notifiedEvent in notifiedEvents {
            for i in 0...state.events.count - 1 {
                if state.events[i].id == notifiedEvent.id {
                    state.events[i].hasBeenNotified = true
                }
            }
        }
    }
}

struct RemoveDebugEvents: StateUpdater {
    func updateState(_ state: inout AppState) {
        state.events.removeAll(where: {$0.id == "test_foreground" || $0.id == "test_background"})
    }
}

struct ScheduleEventsNotifications: StateUpdater {
    func updateState(_ state: inout AppState) {
        print("\(Date()) Entered in ScheduleEventsNotifications StateUpdater")
        var notifiedEvents = [Event]()
        
        if state.isNotficiationEnabled {
            notifiedEvents = LocalNotificationsManager.scheduleEventNotification(events: state.events, places: state.regions)
        }
        
        for notifiedEvent in notifiedEvents {
            print(notifiedEvent.name)
            for event in state.events {
                if event.id == notifiedEvent.id {
                    print("\(event.name) hasBeenNotified == \(event.hasBeenNotified)")
                }
            }
        }
        
        for notifiedEvent in notifiedEvents {
            for i in 0...state.events.count - 1 {
                if state.events[i].id == notifiedEvent.id {
                    state.events[i].hasBeenNotified = true
                }
            }
        }
        
        for notifiedEvent in notifiedEvents {
            print(notifiedEvent.name)
            for event in state.events {
                if event.id == notifiedEvent.id {
                    print("\(event.name) hasBeenNotified == \(event.hasBeenNotified)")
                }
            }
        }
        print("\(Date()) Exited ScheduleEventsNotifications StateUpdater")
    }
}

struct AddMonitoredPlace: StateUpdater {
    var name: String
    var coordinate: [Double]
    var magnitude: Float
    var distance: Double
    func updateState(_ state: inout AppState) {
        state.regions.append(Region(name: name, latitude: coordinate[0], longitudine: coordinate[1], distance: distance, magnitude: magnitude))
    }
}

struct RemoveMonitoredPlace: StateUpdater {
    var index: Int
    func updateState(_ state: inout AppState) {
        state.regions.remove(at: index)
    }
}

struct DeleteOlder: StateUpdater {
    func updateState(_ state: inout AppState) {
        if !state.events.isEmpty {
            let date = Date()
            state.events.forEach{state.events[state.events.firstIndex(of: $0)!].daysAgo = Calendar.current.dateComponents([.day], from: $0.date, to: date).day!}
        }
        let daysAfter = 7
        print("[Before DB cleaning] Events older than \(daysAfter) days: \(state.events.filter{$0.daysAgo >= daysAfter}.count)")
        state.events.removeAll(where: {$0.daysAgo >= daysAfter})
        print("[After DB cleaning] Events older than \(daysAfter) days: \(state.events.filter{$0.daysAgo >= daysAfter}.count)")
    }
}

struct EventsStateUpdater: StateUpdater {
    let newValue: [Event]
    func updateState(_ state: inout AppState) {
        print("\(Date()) Entered EventsStateUpdater StateUpdater")
        let start = CFAbsoluteTimeGetCurrent()
        var setNewValue = Set(newValue)
        for event in state.events {
            if !setNewValue.contains(where: {$0.id == event.id}) {
                setNewValue.insert(event)
            }
        }
        let diff = CFAbsoluteTimeGetCurrent() - start
        print(String(format: "\(Date()) [EventsStateUpdater] Loop took %.2f seconds", diff))
        
        state.events = Array(setNewValue)
        state.events.sort(by: {$0.time > $1.time})
        print("\(Date()) Exited EventsStateUpdater StateUpdater")
    }
}

struct UpdateDaysAgo: StateUpdater {
    func updateState(_ state: inout AppState) {
        print("\(Date()) Entered UpdateDaysAgo StateUpdater")
        let start = CFAbsoluteTimeGetCurrent()
        if !state.events.isEmpty {
            let date = Date()
            state.events.forEach{state.events[state.events.firstIndex(of: $0)!].daysAgo = Calendar.current.dateComponents([.day], from: $0.date, to: date).day!}
        }
        let diff = CFAbsoluteTimeGetCurrent() - start
        print(String(format: "\(Date()) [UpdateDaysAgo] Loop took %.2f seconds", diff))
        print("\(Date()) Exited UpdateDaysAgo StateUpdater")
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
        
        try await(context.dispatch(UpdateDaysAgo()))
        
        let p1 = APIManager.getEventsUSGS(date: date, time: time)
        let p2 = APIManager.getEventsINGV(date: date, time: time)
        let stateEvents = context.getState().events
        
        try await(all(p1, p2).then(in: .utility) { r in
            let usgsData = preprareDataUSGS(newValue: r[0], stateEvents: stateEvents)
            let ingvData = preprareDataINGV(newValue: r[1], stateEvents: stateEvents)
            
            context.dispatch(EventsStateUpdater(newValue: usgsData + ingvData))
        }
        .catch { error in
            print(error.localizedDescription)
        })
        
        context.dispatch(ScheduleEventsNotifications())
        
    }
}

private func preprareDataUSGS(newValue: JSON, stateEvents: [Event]) -> [Event] {
    var returnEvents = [Event]()
    let arrayNames = newValue["features"].arrayValue.map{$0["properties"]["place"].stringValue}
    let description = newValue["features"].arrayValue.map{$0["properties"]["type"].stringValue}
    let magnitudo = newValue["features"].arrayValue.map{$0["properties"]["mag"].stringValue}
    let coord = newValue["features"].arrayValue.map{"\($0["geometry"]["coordinates"][0].stringValue) \($0["geometry"]["coordinates"][1].stringValue)"}
    let id = newValue["features"].arrayValue.map{$0["id"].stringValue}
    let time = newValue["features"].arrayValue.map{$0["properties"]["time"].doubleValue}
    let depth = newValue["features"].arrayValue.map{$0["geometry"]["coordinates"][2].floatValue}
    let updated = newValue["features"].arrayValue.map{$0["properties"]["updated"].doubleValue}
    let magType = newValue["features"].arrayValue.map{$0["properties"]["magType"].stringValue}
    let url = newValue["features"].arrayValue.map{$0["properties"]["url"].stringValue}
    let felt = newValue["features"].arrayValue.map{$0["properties"]["felt"].intValue}
    let dataSource = "USGS"
    
    print("\(Date()) [USGS] JSON decoded")
    
    for i in 0...arrayNames.count - 1 {
        if !stateEvents.contains(where: {$0.id == id[i]}) || stateEvents.contains(where: {$0.id == id[i] && $0.updated != updated[i]}) {
            returnEvents.append(Event(id: id[i], name: arrayNames[i], descr: description[i], magnitudo: magnitudo[i], coordinates: coord[i], depth: depth[i], time: time[i], dataSource: dataSource, updated: updated[i], magType: magType[i], url: url[i], felt: felt[i]))
        }
    }
    // New or updated events
    return returnEvents
}

private func preprareDataINGV(newValue: JSON, stateEvents: [Event]) -> [Event] {
    var returnEvents = [Event]()
    let arrayNames = newValue["features"].arrayValue.map{$0["properties"]["place"].stringValue}
    let description = newValue["features"].arrayValue.map{$0["properties"]["type"].stringValue}
    let magnitudo = newValue["features"].arrayValue.map{$0["properties"]["mag"].stringValue}
    let coord = newValue["features"].arrayValue.map{"\($0["geometry"]["coordinates"][0].stringValue) \($0["geometry"]["coordinates"][1].stringValue)"}
    let id = newValue["features"].arrayValue.map{$0["properties"]["eventId"].stringValue}
    let time_str = newValue["features"].arrayValue.map{$0["properties"]["time"].stringValue}
    let depth = newValue["features"].arrayValue.map{$0["geometry"]["coordinates"][2].floatValue}
    let magType = newValue["features"].arrayValue.map{$0["properties"]["magType"].stringValue}
    let url_tmp = "http://terremoti.ingv.it/event/"
    let felt = 0
    let dataSource = "INGV"
    
    print("\(Date()) [INGV] JSON decoded")
    
    var result_time: [Double] = []
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
    dateFormatter.timeZone = TimeZone(identifier: "UTC")
    
    for time in time_str {
        guard let tmp = dateFormatter.date(from: time) else { return [] }
        result_time.append(tmp.timeIntervalSince1970 * 1000.0)
    }
    
    for i in 0...arrayNames.count - 1 {
        if !stateEvents.contains(where: {$0.id == id[i]}) {
            let url = url_tmp + id[i] + "?timezone=UTC"
            returnEvents.append(Event(id: id[i], name: arrayNames[i], descr: description[i], magnitudo: magnitudo[i], coordinates: coord[i], depth: depth[i], time: result_time[i], dataSource: dataSource, updated: 0, magType: magType[i], url: url, felt: felt))
        }
    }
    // New events
    return returnEvents
}
