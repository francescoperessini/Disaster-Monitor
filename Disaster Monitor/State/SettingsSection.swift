//
//  SettingsSection.swift
//  Disaster Monitor
//
//  Created by Francesco Peressini on 27/02/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

enum SettingsSection: Int, CaseIterable, CustomStringConvertible {
    
    case Message
    case Privacy
    
    var description: String {
        switch self {
        case .Message:
            return "Safe Message"
        case .Privacy:
            return "Privacy"
        }
    }
    
}

enum MessageOption: Int, CaseIterable, CustomStringConvertible {
    
    case editMessage

    var description: String {
        switch self {
        case .editMessage:
            return "Edit Safe Message"
        }
    }
    
}
