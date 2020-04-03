//
//  SettingsTableViewCell.swift
//  Disaster Monitor
//
//  Created by Francesco Peressini on 26/02/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import Tempura

class SettingsTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(notificationSwitch)
        addSubview(segmentedColors)
        addSubview(debugSwitch)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var sectionType: SectionType? {
        didSet {
            guard let sectionType = sectionType else { return }
            textLabel?.text = sectionType.description
            
            notificationSwitch.isHidden = !sectionType.containsNotificationSwitch
            
            segmentedColors.isHidden = !sectionType.containsSegmentedColor
                        
            debugSwitch.isHidden = !sectionType.containsDebugModeSwitch
        }
    }
    
    lazy var notificationSwitch: UISwitch = {
        let notificationSwitch = UISwitch()
        notificationSwitch.addTarget(self, action: #selector(didTapNotificationSwitchFunc), for: .valueChanged)
        return notificationSwitch
    }()
    
    lazy var segmentedColors: UISegmentedControl = {
        let colorSegmented = UISegmentedControl(items: ["Blue", "Green", "Red"])
        colorSegmented.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)
        return colorSegmented
    }()
    
    lazy var debugSwitch: UISwitch = {
        let switch1 = UISwitch()
        switch1.addTarget(self, action: #selector(didTapDebugSwitchFunc), for: .valueChanged)
        return switch1
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        segmentedColors.translatesAutoresizingMaskIntoConstraints = false
        segmentedColors.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        segmentedColors.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        debugSwitch.translatesAutoresizingMaskIntoConstraints = false
        debugSwitch.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        debugSwitch.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        notificationSwitch.translatesAutoresizingMaskIntoConstraints = false
        notificationSwitch.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        notificationSwitch.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
    }
    
    // MARK: - Notification
    var didTapNotificationSwitch: ((Bool) -> ())?

    @objc func didTapNotificationSwitchFunc(sender: UISwitch) {
        didTapNotificationSwitch?(sender.isOn)
    }
    
    func setupNotificationSwitch(value: Bool) {
        notificationSwitch.setOn(value, animated: true)
    }
    
    // MARK: - Debug
    var didTapDebugSwitch: ((Bool) -> ())?
    
    @objc func didTapDebugSwitchFunc(sender: UISwitch) {
        didTapDebugSwitch?(sender.isOn)
    }
    
    func setupDebugSwitch(value: Bool) {
        debugSwitch.setOn(value, animated: true)
    }
    
    // MARK: - Styling
    var didTapStylingColor: ((Color) -> ())?
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        switch sender.titleForSegment(at: sender.selectedSegmentIndex)! {
        case "Blue":
            didTapStylingColor?(Color(name: colors.blue))
        case "Green":
            didTapStylingColor?(Color(name: colors.green))
        case "Red":
            didTapStylingColor?(Color(name: colors.red))
        default:
            break
        }
    }
    
    func setupColorCell(color: Color) {
        segmentedColors.selectedSegmentIndex = ["Blue", "Green", "Red"].firstIndex(of: color.getColorName())!
    }
        
}
