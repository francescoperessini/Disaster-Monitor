//
//  Models.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 17/12/2019.
//  Copyright © 2019 Stefano Martina. All rights reserved.
//

import Foundation

struct Event: Codable, Equatable {
    var id: String
    var name: String
    var description: String
    var magnitudo: Float
    var coordinates: [Double]
    var time: Double
    var daysAgo: Int = 0
    
    init(id: String, name: String, descr: String, magnitudo: String, coordinates: String, time: Double) {
        self.id = id
        self.name = name
        self.description = descr
        self.magnitudo = Float(magnitudo) ?? 0
        let coord1 = Double(coordinates.split(separator: " ")[0]) ?? 0
        let coord2 = Double(coordinates.split(separator: " ")[1]) ?? 0
        self.coordinates = [coord1, coord2]
        self.time = time
        
        let date1 = Date(timeIntervalSince1970: self.time / 1000)
        let date2 = Date()
        
        self.daysAgo = Calendar.current.dateComponents([.day], from: date1, to: date2).day!
    }
    
}

struct DetailedEvent: Codable {
    var id: String
    var name: String
    var description: String
    var magnitudo: Float
    var coordinates: [Double]
    var time: String
    var depth: String
    
    init(id: String, name: String, descr: String, magnitudo: String, coordinates: String, time_in: Double, depth: String) {
        self.id = id
        self.name = name
        self.description = descr
        self.magnitudo = Float(magnitudo) ?? 0
        let coord1 = Double(coordinates.split(separator: " ")[0]) ?? 0
        let coord2 = Double(coordinates.split(separator: " ")[1]) ?? 0
        self.coordinates = [coord1, coord2]
        
        let date = NSDate(timeIntervalSince1970: time_in / 1000)
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        formatter.dateFormat = "d MMM yyyy HH:mm:ss"

        self.time = formatter.string(from: date as Date)
        self.depth = depth
    }
}
