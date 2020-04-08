//
//  MonitoredRegionSection.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 20/03/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

enum MonitoredRegionSection: Int, CaseIterable, CustomStringConvertible {
    
    case MonitoredPlaces
    
    var description: String {
        switch self {
        case .MonitoredPlaces: return "Monitored Places"
        }
    }
    
}
