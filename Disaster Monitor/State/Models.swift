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
    var depth: Float
    var time: Double
    var date: Date
    var daysAgo: Int = 0
    var dataSource: String
    var updated: Double
    
    init(id: String, name: String, descr: String, magnitudo: String, coordinates: String, depth: Float, time: Double, dataSource: String, updated: Double) {
        self.id = id
        self.name = name
        self.description = descr
        self.magnitudo = Float(magnitudo) ?? 0
        let coord1 = Double(coordinates.split(separator: " ")[0]) ?? 0
        let coord2 = Double(coordinates.split(separator: " ")[1]) ?? 0
        self.coordinates = [coord1, coord2]
        
        self.depth = depth
        
        let date = Date(timeIntervalSince1970: (time) / 1000)
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "dd MMM yyyy HH:mm:ss"
        
        self.date = date
        
        self.time = time
        
        let date1 = Date(timeIntervalSince1970: self.time / 1000)
        let date2 = Date()
        self.daysAgo = Calendar.current.dateComponents([.day], from: date1, to: date2).day!
        
        self.dataSource = dataSource
        self.updated = updated
    }
}

struct Region: Codable {
    var latitude: Double
    var longitudine: Double
    var radius: Double
    var magnitude: Float
    
    init(latitude: Double, longitudine: Double, radius: Double, magnitude: Float) {
        self.latitude = latitude
        self.longitudine = longitudine
        self.radius = radius
        self.magnitude = magnitude
    }
}
