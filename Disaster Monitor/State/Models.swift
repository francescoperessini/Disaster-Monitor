//
//  Models.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 17/12/2019.
//  Copyright © 2019 Stefano Martina. All rights reserved.
//

import Foundation

struct Event: Codable, Equatable, Hashable {
    var id: String
    var name: String
    var description: String
    var magnitudo: Float
    var coordinates: [Double]
    var depth: Float
    var time: Double
    var date: Date
    var daysAgo: Int
    var dataSource: String
    var updated: Double
    var magType: String
    var url: String
    var felt: Int
    var hasBeenNotified: Bool
    
    init(id: String, name: String, descr: String, magnitudo: String, coordinates: String, depth: Float, time: Double, dataSource: String,
         updated: Double, magType: String, url: String, felt: Int) {
        self.id = id
        self.name = name
        self.description = descr
        self.magnitudo = Float(magnitudo) ?? 0.0
        let coord1 = Double(coordinates.split(separator: " ")[0]) ?? 0.0
        let coord2 = Double(coordinates.split(separator: " ")[1]) ?? 0.0
        self.coordinates = [coord1, coord2]
        self.depth = depth
        self.time = time
        
        let date = Date(timeIntervalSince1970: time / 1000)
        self.date = date
        
        let date2 = Date()
        self.daysAgo = Calendar.current.dateComponents([.day], from: date, to: date2).day!
        
        self.dataSource = dataSource
        self.updated = updated
        self.magType = magType.uppercased()
        self.url = url
        self.felt = felt
        self.hasBeenNotified = false
    }
}

struct Region: Codable {
    var name: String
    var latitude: Double
    var longitudine: Double
    var distance: Double
    var magnitude: Float
    var dateAdded: Date
    
    init(name: String, latitude: Double, longitudine: Double, distance: Double, magnitude: Float) {
        self.name = name
        self.latitude = latitude
        self.longitudine = longitudine
        self.distance = distance
        self.magnitude = magnitude
        self.dateAdded = Date()
    }
}
