//
//  FilterSection.swift
//  Disaster Monitor
//
//  Created by Francesco Peressini on 13/03/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

protocol FilterSectionType: CustomStringConvertible {
    var containsDescriptionLabel: Bool { get }
    var containsMagnitudeSlider: Bool { get }
    var containsMagnitudeSliderValueLabel: Bool { get }
    var containsTimePeriodSegmentedControl: Bool { get }
    var containsTimePeriodSegmentedControlValueLabel: Bool { get }
    var containsINGVSwitch: Bool { get }
    var containsINGVdescriptionLabel: Bool { get }
    var containsUSGSSwitch: Bool { get }
    var containsUSGSdescriptionLabel: Bool { get }
}

enum FilterSection: Int, CaseIterable, CustomStringConvertible {
    
    case Magnitude
    case Period
    case Source
    
    var description: String {
        switch self {
        case .Magnitude:
            return "Magnitude"
        case .Period:
            return "Time Period"
        case .Source:
            return "Data source"
        }
    }
    
}

enum MagnitudeOption: Int, CaseIterable, FilterSectionType {
    
    case MagnitudeValue
    
    var containsDescriptionLabel: Bool { return true }
    var containsMagnitudeSlider: Bool { return true }
    var containsMagnitudeSliderValueLabel: Bool { return true }
    var containsTimePeriodSegmentedControl: Bool { return false }
    var containsTimePeriodSegmentedControlValueLabel: Bool { return false }
    var containsINGVSwitch: Bool { return false }
    var containsINGVdescriptionLabel: Bool { return false }
    var containsUSGSSwitch: Bool { return false }
    var containsUSGSdescriptionLabel: Bool { return false }
    
    var description: String {
        switch self {
        case .MagnitudeValue:
            return "Magnitude"
        }
    }
    
}

enum PeriodOption: Int, CaseIterable, FilterSectionType {
    
    case PeriodValue
    
    var containsDescriptionLabel: Bool { return true }
    var containsMagnitudeSlider: Bool { return false }
    var containsMagnitudeSliderValueLabel: Bool { return false }
    var containsTimePeriodSegmentedControl: Bool { return true }
    var containsTimePeriodSegmentedControlValueLabel: Bool { return true }
    var containsINGVSwitch: Bool { return false }
    var containsINGVdescriptionLabel: Bool { return false }
    var containsUSGSSwitch: Bool { return false }
    var containsUSGSdescriptionLabel: Bool { return false }
    
    var description: String {
        switch self {
        case .PeriodValue:
            return "Days to be displayed"
        }
    }
    
}

enum SourceOption: Int, CaseIterable, FilterSectionType {
    
    case INGVSource
    case USGSSource
    
    var containsDescriptionLabel: Bool { return false }
    var containsMagnitudeSlider: Bool { return false }
    var containsMagnitudeSliderValueLabel: Bool { return false }
    var containsTimePeriodSegmentedControl: Bool { return false }
    var containsTimePeriodSegmentedControlValueLabel: Bool { return false }
    var containsINGVSwitch: Bool {
        switch self {
        case .INGVSource:
            return true
        case .USGSSource:
            return false
        }
    }
    var containsINGVdescriptionLabel: Bool {
        switch self {
        case .INGVSource:
            return true
        case .USGSSource:
            return false
        }
    }
    var containsUSGSSwitch: Bool {
        switch self {
        case .INGVSource:
            return false
        case .USGSSource:
            return true
        }
    }
    var containsUSGSdescriptionLabel: Bool {
        switch self {
        case .INGVSource:
            return false
        case .USGSSource:
            return true
        }
    }
    
    var description: String {
        switch self {
        case .INGVSource:
            return "INGV 🇮🇹"
        case .USGSSource:
            return "USGS 🇺🇸"
        }
    }
    
}
