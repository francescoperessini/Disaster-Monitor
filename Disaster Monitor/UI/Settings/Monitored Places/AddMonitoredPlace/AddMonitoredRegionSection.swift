//
//  AddMonitoredRegionSection.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 21/03/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

protocol SectionTypeAddMonitored: CustomStringConvertible {
    var containsNameTextField: Bool { get }
    var containsStepperMagnitude: Bool { get }
    var containsStepperDistance: Bool { get }
    var containsMap: Bool { get }
}

enum AddMonitoredRegionSection: Int, CaseIterable, CustomStringConvertible{
    
    case MonitoredPlace
    
    var description: String {
        switch self {
        case .MonitoredPlace: return "Monitored Place"
        }
    }
    
}

enum AddMonitoredPlaceOption: Int, CaseIterable, SectionTypeAddMonitored {
    
    case name
    case magnitudeThreshold
    case distance
    case map
    
    var containsNameTextField: Bool {
        switch self {
        case .name: return true
        default: return false
        }
    }
    
    var containsStepperMagnitude: Bool {
        switch self {
        case .magnitudeThreshold: return true
        default: return false
        }
    }
    
    var containsStepperDistance: Bool {
        switch self {
        case .distance: return true
        default: return false
        }
    }
    
    var containsMap: Bool {
        switch self {
        case .map: return true
        default: return false
        }
    }
    
    var description: String {
        switch self {
        case .name: return "Place's name"
        case .magnitudeThreshold: return "Magnitude Threshold"
        case .distance: return "Max Distance"
        case .map: return "Map"
        }
    }
    
}
