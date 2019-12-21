//
//  Models.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 17/12/2019.
//  Copyright © 2019 Stefano Martina. All rights reserved.
//

import Foundation

struct Event {
    var name: String
    var description: String
    var magnitudo: Float
    var coordinates: [Double]
    var greaterOne: Bool = false
    
    init(name: String, descr: String, magnitudo: String, coordinates: String) {
        self.name = name
        self.description = descr
        self.magnitudo = Float(magnitudo) ?? 0
        
        if self.magnitudo > 1 {
            self.greaterOne = true
        }
        
        let coord1 = Double(coordinates.split(separator: " ")[0]) ?? 0
        let coord2 = Double(coordinates.split(separator: " ")[1]) ?? 0
        
        self.coordinates = [coord1, coord2]
    }
}

struct Profile{
    var name: String
    var surname: String
}
