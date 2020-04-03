//
//  SettingsSection.swift
//  Disaster Monitor
//
//  Created by Francesco Peressini on 27/02/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

protocol SectionType: CustomStringConvertible {
    var containsNotificationSwitch: Bool { get }
    var containsSegmenteColor: Bool { get }
    var containsDebugModeSwitch: Bool { get }
}

enum SettingsSection: Int, CaseIterable, CustomStringConvertible {
    
    case Message
    case Notifications
    case Styling
    case Debug
    
    var description: String {
        switch self {
        case .Message:
            return "Safe Message"
        case .Notifications:
            return "Notification Options"
        case .Styling:
            return "Styling"
        case .Debug:
            return "Debug"
        }
    }
    
}

enum MessageOption: Int, CaseIterable, SectionType {
    
    case editMessage
    
    var containsNotificationSwitch: Bool { return false }
    var containsSegmenteColor: Bool { return false }
    var containsDebugModeSwitch: Bool { return false }
    
    var description: String {
        switch self {
        case .editMessage:
            return "Edit Safe Message"
        }
    }
}

enum NotificationOption: Int, CaseIterable, SectionType {
    
    case enabled
    case places
    
    var containsNotificationSwitch: Bool {
        switch self {
        case .enabled: return true
        case .places: return false
        }
    }
    var containsSegmenteColor: Bool { return false }
    var containsDebugModeSwitch: Bool { return false }
        
    var description: String {
        switch self {
        case .enabled: return "Enable Notifications"
        case .places: return "Monitored Places"
        }
    }
}

enum StylingOption: Int, CaseIterable, SectionType {
    
    case color
    
    var containsNotificationSwitch: Bool { return false }
    var containsSegmenteColor: Bool { return true }
    var containsDebugModeSwitch: Bool { return false }
    
    var description: String {
        switch self {
        case .color: return "Main Tint Color"
        }
    }
}

enum DebugOption: Int, CaseIterable, SectionType {
    
    case DebugMode
    
    var containsNotificationSwitch: Bool { return false }
    var containsSegmenteColor: Bool { return false }
    var containsDebugModeSwitch: Bool { return true }
    
    var description: String {
        switch self {
        case .DebugMode: return "Debug Mode"
        }
    }
}
