//
//  MainSection.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 28/02/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

enum MainSection: Int, CaseIterable, CustomStringConvertible {
    
    case OneDay
    case TwoDay
    case ThreeDay
    case FourDay
    case OthersDay
    
    var description: String {
        switch self {
        case .OneDay:
            return "Today"
        case .TwoDay:
            return "Yesterday"
        case .ThreeDay:
            return "Two Days Ago"
        case .FourDay:
            return "Three Days Ago"
        case .OthersDay:
            return "Previuos Days"
        }
    }
}

enum EventOption: Int, CaseIterable, CustomStringConvertible {
    
    case event

    var description: String {
        switch self {
        case .event:
            return "pippo"
        }
    }
    
}
