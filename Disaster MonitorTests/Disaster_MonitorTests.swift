//
//  Disaster_MonitorTests.swift
//  Disaster MonitorTests
//
//  Created by Stefano Martina on 17/12/2019.
//  Copyright © 2019 Stefano Martina. All rights reserved.
//

import XCTest
@testable import Disaster_Monitor
import Tempura
import TempuraTesting
import Katana

class Disaster_MonitorTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class ScreenTests: XCTestCase{
    
    var events = [Event(id: "111", name: "Test Event", descr: "Test Event", magnitudo: "4", coordinates: "0 0", depth: 2, time: 1588153322902, dataSource: "INGV", updated: 2342343, magType: "ml", url: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.geojson", felt: 0)]
    
    var updatedEvents = [Event(id: "111", name: "Test Event", descr: "Test Event", magnitudo: "5", coordinates: "0 0", depth: 2, time: 1588153322902, dataSource: "INGV", updated: 2442343, magType: "ml", url: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.geojson", felt: 0)]
    
    var fakeStore = Store<AppState, DependenciesContainer>()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

    }
    
    func testAddEvent(){
        fakeStore.dispatch(EventsStateUpdater(newValue: events)).then {
            XCTAssertTrue(self.fakeStore.state.events.contains(self.events[0]))
            XCTAssertTrue(self.fakeStore.state.events[0].magnitudo == 4)
        }
    }
    
    func testUpdateEvent(){
        fakeStore.dispatch(EventsStateUpdater(newValue: updatedEvents)).then {
            XCTAssertTrue(self.fakeStore.state.events[0].magnitudo == 5)
        }
    }
}
