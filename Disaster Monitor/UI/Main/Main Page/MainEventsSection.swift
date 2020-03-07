//
//  MainEventsSection.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 28/02/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

enum MainEventsSection: Int, CaseIterable, CustomStringConvertible {
    
    case Past24
    case Past48
    case Past72
    case Past96
    case PreviousDays
    
    var description: String {
        switch self {
        case .Past24:
            return "Past 24 hours"
        case .Past48:
            return "Past 48 hours"
        case .Past72:
            return "Past 72 hours"
        case .Past96:
            return "Past 96 hours"
        case .PreviousDays:
            return "Previous Days"
        }
    }
}
