//
//  Models.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 17/12/2019.
//  Copyright © 2019 Stefano Martina. All rights reserved.
//

import Foundation

struct Event : Codable{
    var id : String
    var name: String
    var description: String
    var magnitudo: Float
    var coordinates: [Double]
    
    init(id: String, name: String, descr: String, magnitudo: String, coordinates: String) {
        self.id = id
        self.name = name
        self.description = descr
        self.magnitudo = Float(magnitudo) ?? 0
        let coord1 = Double(coordinates.split(separator: " ")[0]) ?? 0
        let coord2 = Double(coordinates.split(separator: " ")[1]) ?? 0
        self.coordinates = [coord1, coord2]
    }
}

struct DetailedEvent : Codable{
    var id : String
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

struct Profile : Codable{
    var name: String
    var surname: String
}
