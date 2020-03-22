//
//  SettingsSection.swift
//  Disaster Monitor
//
//  Created by Francesco Peressini on 27/02/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

protocol SectionType: CustomStringConvertible {
    var containsSegmenteColor: Bool { get }
    var containsSegmentedMap: Bool { get }
    var containsDebugModeSwitch: Bool { get }
    var containsOpenSymbol: Bool { get }
    var containsNotificationSwitch: Bool { get }
}

enum SettingsSection: Int, CaseIterable, CustomStringConvertible {
    
    case Message
    case Privacy
    case Styling
    case AboutUs
    case DataSource
    case Debug
    
    var description: String {
        switch self {
        case .Message:
            return "Safe Message"
        case .Privacy:
            return "Notification customization"
        case .Styling:
            return "Styling"
        case .AboutUs:
            return "About us"
        case .DataSource:
            return "Data Sources"
        case .Debug:
            return "Debug"
        }
    }
    
}

enum MessageOption: Int, CaseIterable, SectionType {
    
    case editMessage
    
    var containsSegmenteColor: Bool { return false }
    var containsSegmentedMap: Bool { return false }
    var containsDebugModeSwitch: Bool { return false }
    var containsOpenSymbol: Bool { return false }
    var containsNotificationSwitch: Bool { return false }
    
    var description: String {
        switch self {
        case .editMessage:
            return "Edit Safe Message"
        }
    }
}

enum PrivacyOption: Int, CaseIterable, SectionType {
    
    case enabled
    case places
    
    
    var containsOpenSymbol: Bool{
        switch self {
        case .places: return true
            default: return false
        }
    }
    
    var containsNotificationSwitch: Bool{
        switch self {
        case .enabled: return true
            default: return false
        }
    }
    
    var containsSegmenteColor: Bool { return false }
    var containsSegmentedMap: Bool { return false }
    var containsDebugModeSwitch: Bool { return false }
        
    var description: String {
        switch self {
            case .enabled: return "Notification enabling"
            case .places: return "Monitored places"
        }
    }
}

enum StylingOption: Int, CaseIterable, SectionType {
    
    case color
    case mapStyle
    
    var containsOpenSymbol: Bool { return false }
    var containsNotificationSwitch: Bool { return false }
    
    var containsSegmenteColor: Bool {
        switch self {
            case .color: return true
            case .mapStyle: return false
        }
    }
    var containsSegmentedMap: Bool {
        switch self {
            case .color: return false
            case .mapStyle: return true
        }
    }
    var containsDebugModeSwitch: Bool { return false }
    
    var description: String {
        switch self {
            case .color: return "Main color"
            case .mapStyle: return "Map style"
        }
    }
}

enum AboutUsOption: Int, CaseIterable, SectionType {
    
    case info
    
    var containsSegmenteColor: Bool { return false }
    var containsSegmentedMap: Bool { return false }
    var containsDebugModeSwitch: Bool { return false }
    var containsOpenSymbol: Bool { return false }
    var containsNotificationSwitch: Bool { return false }
    var description: String{ return "" }
}

enum DataSourceOption: Int, CaseIterable, SectionType {
    
    case info
    
    var containsSegmenteColor: Bool { return false }
    var containsSegmentedMap: Bool { return false }
    var containsDebugModeSwitch: Bool { return false }
    var containsOpenSymbol: Bool { return false }
    var containsNotificationSwitch: Bool { return false }
    var description: String{ return "" }
}

enum DebugOption: Int, CaseIterable, SectionType {
    
    case DebugMode
    
    var containsSegmenteColor: Bool { return false }
    var containsSegmentedMap: Bool { return false }
    var containsDebugModeSwitch: Bool { return true }
    var containsOpenSymbol: Bool { return false }
    var containsNotificationSwitch: Bool { return false }
    
    var description: String {
        switch self {
        case .DebugMode: return "Debug Mode"
        }
    }
    
}
