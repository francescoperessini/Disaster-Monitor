//
//  AddMonitoredRegionSection.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 21/03/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

protocol SectionTypeAddMonitored: CustomStringConvertible {
    var containsNameTextField: Bool { get }
    var containsStepperMagnitudo: Bool { get }
    var containsStepperRadius: Bool { get }
    var containsMap: Bool { get }
}

enum AddMonitoredRegionSection: Int, CaseIterable, CustomStringConvertible{
    
    case MonitoredRegion
    
    var description: String {
        switch self {
            case .MonitoredRegion: return "Monitored Regions"
        }
    }
}

enum AddMonitoredRegionOption: Int, CaseIterable, SectionTypeAddMonitored {
    case name
    case magnitudoThreshold
    case radius
    case map
    
    var description: String {
        switch self {
        case .name: return "Monitored place's name"
            case .magnitudoThreshold: return "Magnitudo Threshold"
            case .radius: return "Radius"
            case .map: return "map"
        }
    }
    
    var containsNameTextField: Bool{
        switch self {
        case .name: return true
        default: return false
        }
    }
    
    var containsStepperMagnitudo: Bool{
        switch self {
            case .magnitudoThreshold:   return true
            default:    return false
        }
    }
    var containsStepperRadius: Bool{
        switch self {
            case .radius:   return true
            default:    return false
        }
    }
    var containsMap: Bool{
        switch self {
            case .map:   return true
            default:    return false
        }
    }
    
}
