//
//  Disaster_MonitorTests.swift
//  Disaster MonitorTests
//
//  Created by Stefano Martina on 17/12/2019.
//  Copyright © 2019 Stefano Martina. All rights reserved.
//

import Quick
import Nimble
import Katana
@testable import Disaster_Monitor

class StateUpdaterTests: QuickSpec {
    override func spec() {
        describe("The Store") {
            var store: Store<AppState, DependenciesContainer>!
            
            beforeEach {
                store = Store<AppState, DependenciesContainer>()
            }
            
            it("is able to update the state (SetMessage)") {
                
                let newSafeMessage = "New Message"
                
                expect(store.isReady).toEventually(beTruthy())
                expect(store.state.message) == "Message to be shared\nSent from Disaster Monitor App"
                
                waitUntil { done in
                    store
                        .dispatch(SetMessage(newMessage: newSafeMessage))
                        .then {
                            expect(store.state.message) == "New Message"
                            done()
                    }
                }
            }
            
            it("is able to update the state (SetNotificationMode)") {
                
                let notification = false
                
                expect(store.isReady).toEventually(beTruthy())
                expect(store.state.isNotficiationEnabled) == true
                
                waitUntil { done in
                    store
                        .dispatch(SetNotificationMode(value: notification))
                        .then {
                            expect(store.state.isNotficiationEnabled) == false
                            done()
                    }
                }
            }
            
            it("dispatches state updaters serially when using promises (Events)") {
                
                let events = [Event(id: "111", name: "Test Event", descr: "Test Event", magnitudo: "4", coordinates: "0 0", depth: 2, time: 1588153322902, dataSource: "USGS", updated: 2342343, magType: "ml", url: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.geojson", felt: 0)]
                
                let updatedEvents = [Event(id: "111", name: "Test Event", descr: "Test Event", magnitudo: "5", coordinates: "0 0", depth: 2, time: 1588153322902, dataSource: "USGS", updated: 2342343, magType: "ml", url: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.geojson", felt: 0)]
                
                expect(store.isReady).toEventually(beTruthy())
                expect(store.state.events.isEmpty) == true
                
                waitUntil { done in
                    store
                        .dispatch(EventsStateUpdater(newValue: events))
                        .then {
                            expect(store.state.events.count) == 1
                            expect(store.state.events.contains(events[0])) == true
                            expect(store.state.events[0].magnitudo) == 4
                    }
                    .thenDispatch(EventsStateUpdater(newValue: updatedEvents))
                    .then {
                        expect(store.state.events.count) == 1
                        expect(store.state.events.contains(updatedEvents[0])) == true
                        expect(store.state.events[0].magnitudo) == 5
                        done()
                    }
                }
            }
            
            it("dispatches state updaters serially when using promises (Regions)") {
                
                let name = "Test region"
                let coordinates = [40.0, 70.0]
                let magnitude = 6.0
                let distance = 5.0
                
                expect(store.isReady).toEventually(beTruthy())
                expect(store.state.regions.isEmpty) == true
                
                waitUntil { done in
                    store
                        .dispatch(AddMonitoredPlace(name: name, coordinate: coordinates, magnitude: Float(magnitude), distance: distance))
                        .then {
                            expect(store.state.regions.count) == 1
                            expect(store.state.regions[0].name) == "Test region"
                            expect(store.state.regions[0].latitude) == 40.0
                            expect(store.state.regions[0].longitudine) == 70.0
                            expect(store.state.regions[0].magnitude) == 6.0
                            expect(store.state.regions[0].distance) == 5.0
                    }
                    .thenDispatch(RemoveMonitoredPlace(index: 0))
                    .then {
                        expect(store.state.events.count) == 0
                        done()
                    }
                }
            }
        }
    }
}
