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

struct Profile : Codable{
    var name: String
    var surname: String
}
