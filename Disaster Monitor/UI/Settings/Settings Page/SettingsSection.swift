//
//  SettingsSection.swift
//  Disaster Monitor
//
//  Created by Francesco Peressini on 27/02/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

protocol SectionType : CustomStringConvertible{
    var containsStepperMagnitudo: Bool { get  }
    var containsStepperRadius: Bool { get }
}

enum SettingsSection: Int, CaseIterable, CustomStringConvertible {
    
    case Message
    case Privacy
    
    var description: String {
        switch self {
        case .Message:
            return "Safe Message"
        case .Privacy:
            return "Notification customization"
        }
    }
    
}

enum MessageOption: Int, CaseIterable, SectionType {
    case editMessage
    
    var containsStepperMagnitudo: Bool{ return false }
    var containsStepperRadius: Bool { return false }
    
    var description: String {
        switch self {
        case .editMessage:
            return "Edit Safe Message"
        }
    }
}

enum PrivacyOption: Int, CaseIterable, SectionType{
    case radius
    case places
    case magnitudo
    
    var containsStepperRadius: Bool{
        switch self {
            case .radius: return true
            default: return false
        }
    }
    var containsStepperMagnitudo: Bool{
        switch self {
            case .magnitudo: return true
            default: return false
        }
    }
        
    var description: String{
        switch self {
        case .radius: return "Notification Radius"
        case .places: return "Monitored places"
        case .magnitudo: return "Magnitudo"
        }
    }
}

