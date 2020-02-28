//
//  MainSection.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 28/02/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

enum MainSection: Int, CaseIterable, CustomStringConvertible {
    
    case Event
    
    var description: String {
        switch self {
        case .Event:
            return "Last events"
        
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
