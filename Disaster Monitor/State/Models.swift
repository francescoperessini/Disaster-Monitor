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
        
        //Calcolo giorni fa
        let today = Date()
        let formatter_today = DateFormatter()
        formatter_today.dateFormat = "dd.MM.yyyy"
        let result_today = formatter_today.string(from: today)
        let lines_today = result_today.components(separatedBy: ".")
        let calendar_today = Calendar.current
        let dateA = DateComponents(calendar: calendar_today,
                                            year: Int(lines_today[2]),
                                            month: Int(lines_today[1]),
                                            day: Int(lines_today[0]))
        
        
        let date = NSDate(timeIntervalSince1970: self.time / 1000)
        let formatter_date = DateFormatter()
        formatter_date.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        formatter_date.dateFormat = "dd.MM.yyyy"
        let result_date = formatter_today.string(from: date as Date)
        let lines_date = result_date.components(separatedBy: ".")
        let calendar_date = Calendar.current
        let dateB = DateComponents(calendar: calendar_date,
                                            year: Int(lines_date[2]),
                                            month: Int(lines_date[1]),
                                            day: Int(lines_date[0]))
        
        
        let diffInDays = Calendar.current.dateComponents([.day], from: dateB, to: dateA).day ?? 0
        
        self.daysAgo = diffInDays
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
