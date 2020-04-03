//
//  SettingsTableViewCell.swift
//  Disaster Monitor
//
//  Created by Francesco Peressini on 26/02/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import Tempura

class SettingsTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var sectionType: SectionType? {
        didSet {
            guard let sectionType = sectionType else { return }
            textLabel?.text = sectionType.description
            
            segmentedColors.isHidden = !sectionType.containsSegmenteColor
                        
            debugSwitch.isHidden = !sectionType.containsDebugModeSwitch
            
            openImageView.isHidden = !sectionType.containsOpenSymbol
            
            notificationSwitch.isHidden = !sectionType.containsNotificationSwitch
        }
    }
    
    
    lazy var openImageView: UIImageView = {
        let img = UIImageView(image: UIImage(systemName: "􀆂"))
        return img
    }()
    
    lazy var segmentedColors: UISegmentedControl = {
        let colorSegmented = UISegmentedControl(items: ["Blue", "Green", "Red"])
        colorSegmented.addTarget(self, action: #selector(handleTapStylingColor), for: .valueChanged)

        return colorSegmented
    }()
    
    lazy var debugSwitch: UISwitch = {
        let switch1 = UISwitch()
        switch1.addTarget(self, action: #selector(didTapSwitchFunc), for: .valueChanged)
        return switch1
    }()
    
    lazy var notificationSwitch: UISwitch = {
        let notificationSwitch = UISwitch()
        notificationSwitch.addTarget(self, action: #selector(didTapNotificationSwitchFunc), for: .valueChanged)
        return notificationSwitch
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        segmentedColors.translatesAutoresizingMaskIntoConstraints = false
        segmentedColors.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        segmentedColors.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        
        debugSwitch.translatesAutoresizingMaskIntoConstraints = false
        debugSwitch.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        debugSwitch.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        
        openImageView.translatesAutoresizingMaskIntoConstraints = false
        openImageView.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        openImageView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        
        notificationSwitch.translatesAutoresizingMaskIntoConstraints = false
        notificationSwitch.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        notificationSwitch.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        
        self.addSubview(segmentedColors)
                
        self.addSubview(debugSwitch)
        
        self.addSubview(openImageView)
        
        self.addSubview(notificationSwitch)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - StateInitializer
    func setupColorCell(color: Color) {
        self.segmentedColors.selectedSegmentIndex = ["Blue", "Green", "Red"].firstIndex(of: color.getColorName()) ?? 0
    }
    
    func setupDebugSwitch(value: Bool) {
        self.debugSwitch.setOn(value, animated: true)
    }
    
    // MARK: - Selectors
    var didTapStylingColor: ((Color) -> ())?
    
    @objc func handleTapStylingColor(sender: UISegmentedControl) {
        let selectedColor = sender.titleForSegment(at: sender.selectedSegmentIndex)!
        switch selectedColor {
            case "Red": didTapStylingColor?(Color(name: colors.red))
            case "Green": didTapStylingColor?(Color(name: colors.green))
            default: didTapStylingColor?(Color(name: colors.blue))
        }
    }
    
    var didTapSwitch: ((Bool) -> ())?
    var didTapNotificationSwitch: ((Bool) -> ())?
    
    @objc func didTapSwitchFunc(sender: UISwitch) {
        didTapSwitch?(sender.isOn)
    }
    
    @objc func didTapNotificationSwitchFunc(sender: UISwitch) {
        didTapNotificationSwitch?(sender.isOn)
    }
}
